import 'package:flutter/material.dart';
import 'wistia_player_flags.dart';
import 'wistia_player_value.dart';

class WistiaPlayerController extends ValueNotifier<WistiaPlayerValue> {
  /// The video id of the Wistia video to play
  final String videoId;

  /// Composes all the flags required to control the player
  final WistiaPlayerFlags flags;

  /// Creates [WistiaPlayerController].
  WistiaPlayerController({
    required this.videoId,
    this.flags = const WistiaPlayerFlags(),
  }) : super(WistiaPlayerValue());

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  _callMethod(String methodString) {
    if (value.isReady) {
      value.webViewController?.evaluateJavascript(methodString);
    } else {
      print('The controller is not ready for method calls.');
    }
  }

  bool _isDisposed = false;

  /// Returns whether or not the disposed is called on this controller.
  bool get hasDisposed => _isDisposed;

  /// Plays the video
  void play() => _callMethod('play()');

  /// Pauses the video.
  void pause() => _callMethod('pause()');

  /// Disables audio on the video
  void mute() => _callMethod('mute()');

  /// Enables audio on the video if it had been disabled via mute(). The video’s volume before it was muted will be restored.
  void unmute() => _callMethod('unmute()');

  /// Updates the old [WistiaPlayerOptions] with new one provided.
  void updateValue(WistiaPlayerValue newValue) => value = newValue;
}
