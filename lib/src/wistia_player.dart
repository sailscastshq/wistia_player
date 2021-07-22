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

  /// Converts fully qualified Wistia Url to video id.
  ///
  /// If videoId is passed as url then we will skip conversion.
  /// This will match:
  /// http://home.wistia.com/medias/e4a27b971d
  /// https://home.wistia.com/medias/e4a27b971d
  /// http://home.wi.st/medias/e4a27b971d
  /// http://home.wistia.com/embed/e4a27b971d
  /// https://home.wistia.com/embed/e4a27b971d
  /// https://home.wi.st/embed/e4a27b971d
  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    bool isWistiaVideoId =
        !url.contains(RegExp(r'https?:\/\/')) && url.length == 10;

    if (isWistiaVideoId) return url;

    if (trimWhitespaces) url = url.trim();

    var wistiaShareLinkPattern = RegExp(
        r"https?:\/\/(?:www\.)?\w+\.(wistia\.com|wi\.st)\/(medias|embed)\/(\w{10}).*");

    RegExpMatch? match = wistiaShareLinkPattern.firstMatch(url);
    return match?.group(3);
  }

  @override
  _WistiaPlayerState createState() => _WistiaPlayerState();
}

class _WistiaPlayerState extends State<WistiaPlayer>
    with WidgetsBindingObserver {
  WistiaPlayerController? controller;
  WistiaPlayerState? _cachedPlayerState;
  bool _initialLoad = true;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    if (!widget.controller.hasDisposed) {
      this.controller = widget.controller..addListener(listener);
    }

    super.initState();
  }

  void listener() async {
    if (controller == null) return;
    if (_initialLoad) {
      _initialLoad = false;
      controller?.updateValue(controller!.value.copyWith(
          autoPlay: controller?.options.autoPlay,
          controlsVisibleOnLoad: controller?.options.controlsVisibleOnLoad,
          copyLinkAndThumbnailEnabled:
              controller?.options.copyLinkAndThumbnailEnabled,
          doNotTrack: controller?.options.doNotTrack,
          email: controller?.options.email,
          endVideoBehavior: controller?.options.endVideoBehavior,
          fakeFullScreen: controller?.options.fakeFullScreen,
          fitStrategy: controller?.options.fitStrategy,
          fullscreenButton: controller?.options.fullscreenButton,
          fullscreenOnRotateToLandscape:
              controller?.options.fullscreenOnRotateToLandscape,
          googleAnalytics: controller?.options.googleAnalytics,
          playbackRateControl: controller?.options.playbackRateControl,
          playbar: controller?.options.playbar,
          playButton: controller?.options.playButton,
          playerColor: controller?.options.playerColor,
          playlistLinks: controller?.options.playlistLinks,
          playlistLoop: controller?.options.playlistLoop,
          playsinline: controller?.options.playsinline,
          playSuspendedOffScreen: controller?.options.playSuspendedOffScreen,
          preload: controller?.options.preload,
          qualityControl: controller?.options.qualityControl,
          qualityMax: controller?.options.qualityMax,
          qualityMin: controller?.options.qualityMin,
          resumable: controller?.options.resumable,
          seo: controller?.options.seo,
          settingsControl: controller?.options.settingsControl,
          silentAutoPlay: controller?.options.silentAutoPlay,
          smallPlayButton: controller?.options.smallPlayButton,
          stillUrl: controller?.options.stillUrl,
          time: controller?.options.time,
          thumbnailAltText: controller?.options.thumbnailAltText,
          videoFoam: controller?.options.videoFoam,
          volume: controller?.options.volume,
          volumeControl: controller?.options.volumeControl,
          wmode: controller?.options.wmode));
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    controller?.removeListener(listener);
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
      key: widget.key,
      initialUrl: 'about:blank',
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
    controller?.updateValue(
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
                controller
                    ?.updateValue(controller!.value.copyWith(isReady: true));
                break;
              }
            case 'Ended':
              {
                print('Video has ended');
                if (widget.onEnded != null) {
                  widget.onEnded!(WistiaMetaData.fromJson(jsonMessage));
                }
              }
          }
        });
  }

  void _onWebViewCreated(WebViewController webViewController) {
    webViewController.loadUrl(
      Uri.dataFromString(
        _buildWistiaHTML(controller!),
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
    );

    controller?.updateValue(
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
            iframe, .player {
              display: block;
              width: 100%;
              height: 100%;
              border: none;
              }
            </style>
            <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
        </head>
        <body>
           <script src="https//fast.wistia.com/embed/medias/${controller.videoId}.jsonp" async></script>
           <script src="https://fast.wistia.com/assets/external/E-v1.js" async></script>
           <div class="wistia_embed wistia_async_${controller.videoId} ${controller.options.toString()} player">&nbsp;</div>
          <script>
          window._wq = window._wq || []
          _wq.push({
            id: ${controller.videoId},
            onReady: function(video) {
                if (video.hasData()) {
                  sendMessageToDart('Ready');
                }
                video.bind("play", function() {
                  sendMessageToDart('Playing')
                })

                video.bind('pause', function() {
                  sendMessageToDart('Paused')
                })
                video.bind("end", function(endTime) {
                  sendMessageToDart('Ended', { endTime: endTime });
                })

                video.bind("percentwatchedchanged", function(percent, lastPercent) {
                  sendMessageToDart('PercentChanged', { percent, percent, lastPercent: lastPercent })
                })

                video.bind("mutechange", function (isMuted)) {
                  sendMessageToDart('MuteChange', { isMuted: isMuted })
                }

                video.bind("enterfullscreen", function() {
                  sendMessageToDart('EnterFullscreen')
                })

                video.bind("cancelfullscreen", function() {
                  sendMessageToDart('CancelFullscreen')
                })

                video.bind("beforeremove", function() {
                  return video.unbind
                })

                window.play = function play() {
                  return video.play();
                }
                window.pause = function pause() {
                  return video.pause();
                }
                window.isMuted = function isMuted() {
                  return video.isMuted()
                }

                window.inFullscreen = function inFullscreen() {
                  return video.inFullscreen()
                }

                window.hasData = function hasData() {
                  return video.hasData()
                }

                window.aspect = function aspect() {
                  return video.aspect()
                }

                window.mute = function mute() {
                  return video.mute()
                }

                window.unmute = function unmute() {
                  return video.unmute()
                }

                window.duration = function duration() {
                  return video.duration()
                }
              },
          });

          function sendMessageToDart(methodName, argsObject = {}) {
            var message = {
              'method': methodName,
              'args': argsObject
            };
            WistiaWebView.postMessage(JSON.stringify(message));
          }
          </script>
        </body>
      </html>
    ''';
  }

  String? get userAgent => controller!.options.forceHD
      ? 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36'
      : null;
}
