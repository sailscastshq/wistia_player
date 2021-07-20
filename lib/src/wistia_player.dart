import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wistia_player/src/enums/wistia_player_state.dart';
import 'wistia_player_controller.dart';
import 'wistia_meta_data.dart';

class WistiaPlayer extends StatefulWidget {
  /// Sets [Key] as an identification to underlying web view associated to the Wistia player.
  final Key? key;
  final WistiaPlayerController controller;

  final void Function(WistiaMetaData metaData)? onEnded;

  /// Creates a [WistiaPlayer] widget.
  WistiaPlayer({this.key, this.onEnded, required this.controller});

  @override
  _WistiaPlayerState createState() => _WistiaPlayerState();
}

class _WistiaPlayerState extends State<WistiaPlayer>
    with WidgetsBindingObserver {
  WistiaPlayerController? controller;
  WistiaPlayerState? _cachedPlayerState;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    if (!widget.controller.hasDisposed) {
      this.controller = widget.controller;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_cachedPlayerState != null &&
            _cachedPlayerState == WistiaPlayerState.playing) {
          controller?.play();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _cachedPlayerState = controller?.value.playerState;
        controller?.pause();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      allowsInlineMediaPlayback: true,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: _onWebViewCreated,
      onWebResourceError: _handleWebResourceError,
      debuggingEnabled: true,
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      javascriptChannels: Set()..add(_getJavascriptChannel()),
      userAgent: userAgent,
    );
  }

  void _handleWebResourceError(WebResourceError error) {
    controller!.updateValue(
      controller!.value.copyWith(
          errorCode: error.errorCode, errorMessage: error.description),
    );
    print(error);
  }

  JavascriptChannel _getJavascriptChannel() {
    return JavascriptChannel(
        name: 'WistiaWebView',
        onMessageReceived: (JavascriptMessage message) {
          Map<String, dynamic> jsonMessage = jsonDecode(message.message);
          switch (jsonMessage['method']) {
            case 'Ready':
              {
                controller!
                    .updateValue(controller!.value.copyWith(isReady: true));
                break;
              }
            case 'Ended':
              {
                if (widget.onEnded != null) {
                  widget.onEnded!(WistiaMetaData.fromJson(jsonMessage));
                }
              }
          }
        });
  }

  void _onWebViewCreated(WebViewController webViewController) {
    webViewController.loadUrl(Uri.dataFromString(_buildWistiaHTML(controller!),
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());

    controller!.updateValue(
      controller!.value.copyWith(webViewController: webViewController),
    );
  }

  String _buildWistiaHTML(WistiaPlayerController controller) {
    return '''
      <!DOCTYPE html>
      <html>
        <head>
        <style>
          html,
            body {
                margin: 0;
                padding: 0;
                background-color: #000000;
                opacity: 0
                overflow: hidden;
                position: fixed;
                height: 100%;
                width: 100%;
            }
            iframe {display: block; width: 100%; height: 100%; border: none;}
            </style>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
        </head>
        <body>
          <iframe src="https://fast.wistia.net/embed/iframe/${controller.videoId}?autoPlay=true&fitStrategy=fill&videoFoam=true&endVideoBehavior=loop&fullscreenButton=true&fullscreenOnRotateToLandscape=true&resume=true" allowtransparency="true" frameborder="0" scrolling="no" class="wistia_embed" name="wistia_embed" allowfullscreen mozallowfullscreen webkitallowfullscreen oallowfullscreen msallowfullscreen></iframe>
          <script src="//fast.wistia.net/assets/external/E-v1.js" async></script>
          <script>
          window._wq = window._wq || [];
          _wq.push({ id: '${controller.videoId}',
           onReady: function(video) {
            console.log("I got a handle to the video!", video);
            video.bind("play", function() {
              return video.unbind
            })
            video.bind("end", function(t) {
              sendMessageToDart('Ended', { 'endTime': t })
            })
          }})

          function sendMessageToDart(methodName, argsObject = {}) {
            var message = {
              'method': methodName,
              'args': argsObject
            }
            WistiaWebView.postMessage(JSON.stringify(message))
          }
          </script>
        </body>
      </html>
    ''';
  }

  String? get userAgent => controller!.flags.forceHD
      ? 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36'
      : null;
}
