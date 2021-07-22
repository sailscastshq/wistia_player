import 'package:flutter/material.dart';
import 'wistia_player_options.dart';
import 'wistia_player_value.dart';

class WistiaPlayerController extends ValueNotifier<WistiaPlayerValue> {
  /// The video id of the Wistia video to play
  final String videoId;

  /// Composes all the options required to control the player
  final WistiaPlayerOptions options;

  /// Creates [WistiaPlayerController].
  WistiaPlayerController({
    required this.videoId,
    this.options = const WistiaPlayerOptions(),
  }) : super(WistiaPlayerValue());

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  _callMethod(String methodString) {
    value.webViewController?.evaluateJavascript(methodString);
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

  /// Enables audio on the video if it had been disabled via mute().
  ///
  /// The video’s volume before it was muted will be restored.
  void unmute() => _callMethod('unmute()');

  /// Updates the old [WistiaPlayerOptions] with new one provided.
  void updateValue(WistiaPlayerValue newValue) => value = newValue;

  /// Returns the aspect ratio (width / height) of the originally uploaded video.
  ///
  /// ```dart
  /// if (video.aspect() < 1) {
  ///   console.log("vertical video");
  /// } else if (video.aspect() > 1) {
  ///    console.log("horizontal video");
  /// } else {
  ///   console.log("This video is square.");
  /// }
  /// ```
  ///
  num aspect() => _callMethod('aspect()');

  /// If video is playing in fullscreen mode, calling this method will exit fullscreen.
  void cancelFullscreen() => _callMethod('cancelFullscreen()');

  /// Returns the duration of the video in seconds. This will return 0 until video.hasData() is true.
  num duration() => _callMethod('duration()');

  /// Returns the email associated with this viewing session.
  ///
  /// If no email is associated, it will return null.
  String? email(String? email) =>
      email != null ? _callMethod('email($email)') : _callMethod('email()');

  /// Returns true if the video has been embedded, false if it hasn’t yet.
  ///
  /// We define “embedded” as the video’s markup having been visibly injected into the DOM.
  bool embedded() => _callMethod('embedded()');

  /// Returns the value of the multiplier that’s scaling the size of your captions.
  num getSubtitlesScale() => _callMethod('getSubtitlesScale()');

  /// Returns true if the video has received data from the Wistia server, false if not.
  ///
  /// The data includes information like which video files are available, the name and duration of the video, and its customizations.
  bool hasData() => _callMethod('hasData()');

  /// Returns the hashed ID associated with this video.
  ///
  /// The hashed ID is an alphanumeric string that uniquely identifies your video in Wistia.
  String hashId() => _callMethod('hashId()');

  /// Returns the current height of the video container in pixels.
  int height(int? val, {Map<String, dynamic>? options}) => val != null
      ? _callMethod('height($val, $options)')
      : _callMethod('height()');

  /// Returns true if the video is currently playing in fullscreen, false if not.
  bool inFullscreen() => _callMethod('inFullscreen()');

  /// Returns true if the video is muted.
  bool isMuted() => _callMethod('isMuted()');
}
