library wistia_player;

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wistia_player/src/enums/wistia_player_state.dart';
import 'src/wistia_player_controller.dart';
import 'src/wistia_meta_data.dart';

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
    );
  }
}
