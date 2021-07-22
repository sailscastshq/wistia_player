import 'package:flutter/foundation.dart';
import 'package:wistia_player/src/enums/end_video_behavior.dart';
import 'package:wistia_player/src/enums/fit_strategy.dart';
import 'package:wistia_player/src/enums/preload.dart';

class WistiaPlayerOptions {
  final bool forceHD;

  /// If set to true, the video will play as soon as it’s ready.
  final bool autoPlay;

  /// If set to true, controls like the big play button, playbar, volume, etc. will be visible as soon as the video is embedded. Default is true.
  final bool controlsVisibleOnLoad;

  /// If set to false, once your video is embedded on a webpage, the option to “Copy Link and Thumbnail” when you right click on your video will be removed.
  final bool copyLinkAndThumbnailEnabled;
  final bool doNotTrack;
  final String? email;
  final EndVideoBehavior endVideoBehavior;
  final bool fakeFullScreen;
  final FitStrategy fitStrategy;
  final bool fullscreenButton;
  final bool fullscreenOnRotateToLandscape;
  final bool googleAnalytics;
  final playbackRateControl;
  final bool playbar;
  final bool playButton;

  /// Changes the base color of the player.
  /// Expects a hexadecimal rgb string like “ff0000” (red), “000000” (black), “ffffff” (white), or “0000ff” (blue).
  final String? playerColor;

  /// The playlistLinks option lets you associate specially crafted links on your page with a video, turning them into a playlist. For information about how this works, check out the Embed Links documentation.
  /// https://wistia.com/support/developers/embed-links#special-playlist-options
  final String? playlistLinks;

  /// When set to true and this video has a playlist,
  /// it will loop back to the first video and replay it once the last video has finished.
  final bool playlistLoop;

  /// When set to false, your videos will play within the native mobile player instead of our own.
  /// This can be helpful if, for example, you would prefer that your mobile viewers start the video in fullscreen mode upon pressing play.
  final bool playsinline;

  /// When a video is set to autoPlay=muted, it will pause playback when the video is out of view.
  /// For example, if the video is at the top of a page and you scroll down past it, the video will pause until you scroll back up to see the video again.
  /// To prevent a muted autoplay video from pausing when out of view, you can set this to playSuspendedOffScreen=false.
  final bool playSuspendedOffScreen;

  /// This sets the video’s preload property. Possible values are metadata, auto, none, true, and false.
  final Preload preload;

  /// If set to false, the video quality selector in the settings menu will be hidden.
  final bool qualityControl;

  /// Setting a qualityMax allows you to specify the maximum quality the video will play at.
  /// Wistia will still run bandwidth checks to test for speed, and play the highest quality version at or below the set maximum.
  /// Accepted values: 224, 360, 540, 720, 1080, 3840.
  /// Keep in mind, viewers will still be able to manually select a quality outside set maximum (using the option on the player) unless qualityControl is set to false.
  final int qualityMax;

  /// Setting a qualityMin allows you to specify the minimum quality the video will play at.
  /// Wistia will still run bandwidth checks to test for speed, and play the highest quality version at or above the set minimum.
  /// Accepted values: 224, 360, 540, 720, 1080, 3840.
  /// Keep in mind, viewers will still be able to manually select a quality outside set minimum (using the option on the player) unless qualityControl is set to false.
  final int qualityMin;

  /// The resumable feature causes videos to pick up where the viewer left off next time they load the page where your video is embedded.
  /// Possible values for the resumable embed option are true, false, and auto. Defaults to auto.
  /// If auto, the resumable feature will only be enabled if the video is 5 minutes or longer, is not autoplay, and is not set to loop at the end.
  /// Setting resumable to true will enable resumable regardless of those factors, and false disables resumable no matter what.
  final dynamic resumable;

  /// If set to true, the video’s metadata will be injected into the page’s on-page markup. Set it to false if you don’t want SEO metadata injection.
  /// For more information about how this works, check out the video SEO page.
  /// https://wistia.com/product/video-seo
  final bool seo;

  /// If set to true, the settings control will be available.
  /// This will allow viewers to control the quality and playback speed of the video.
  /// See qualityControl and playbackRateControl if you want control of what is available in the settings control.
  final bool settingsControl;

  /// This option allows videos to autoplay in a muted state in contexts where normal autoplay is blocked or not supported (e.g. iOS, Safari 11+, Chrome 66+).
  final dynamic silentAutoPlay;

  /// If set to true, the small play button control will be available.
  final bool smallPlayButton;

  /// Overrides the thumbnail image that appears before the video plays.
  /// Expects an absolute URL to an image. For best results, the image should match the exact aspect ratio of the video.
  final String? stillUrl;

  /// Set the time at which the video should start. Expects an integer value in seconds or string values like "5m45s".
  /// This is equivalent to running video.time(t) immediately after initialization.
  final dynamic time;

  /// Set the Thumbnail Alt Text for your media.
  /// Changing the Alt Text via this method will set new Alt Text or override the Alt Text set in the customization menu.
  final String? thumbnailAltText;

  /// When set to true, the video will monitor the width of its parent element.
  /// When that width changes, the video will match that width and modify its height to maintain the correct aspect ratio.
  /// You can set maximum or minimum widths and heights that videoFoam will honor.
  final dynamic videoFoam;

  /// Set the volume of the video. Expects an integer value between 0 and 1.
  /// This is equivalent to running video.volume(v) immediately after initialization.
  final int volume;

  /// When set to true, a volume control is available over the video.
  /// NOTE: On mobile devices where we use the native volume controls, this option has no effect.
  final bool volumeControl;

  /// When set to transparent, the background behind the video player will be transparent -
  /// allowing the page color to show through - instead of black.
  /// This applies e.g. if there’s an aspect ratio discrepancy between the dimensions of the video and its container; this option is not connected to Alpha Transparency.
  final String wmode;

  const WistiaPlayerOptions({
    this.forceHD = false,
    this.autoPlay = true,
    this.controlsVisibleOnLoad = true,
    this.copyLinkAndThumbnailEnabled = false,
    this.doNotTrack = false,
    this.email,
    this.endVideoBehavior = EndVideoBehavior.wsDefault,
    this.fakeFullScreen = false,
    this.fitStrategy = FitStrategy.contain,
    this.fullscreenButton = true,
    this.fullscreenOnRotateToLandscape = true,
    this.googleAnalytics = false,
    this.playbackRateControl = true,
    this.playbar = true,
    this.playButton = false,
    this.playerColor,
    this.playlistLinks,
    this.playlistLoop = false,
    this.playsinline = true,
    this.playSuspendedOffScreen = true,
    this.preload = Preload.auto,
    this.qualityControl = true,
    this.qualityMax = 1080,
    this.qualityMin = 720,
    this.resumable = true,
    this.seo = false,
    this.settingsControl = true,
    this.silentAutoPlay = 'allow',
    this.smallPlayButton = false,
    this.stillUrl,
    this.time,
    this.thumbnailAltText,
    this.videoFoam,
    this.volume = 1,
    this.volumeControl = true,
    this.wmode = 'transparent',
  });

  get getEndVideoBehavior {
    String behavior = describeEnum(this.endVideoBehavior);
    if (behavior == 'wsDefault') {
      return 'default';
    }
    return behavior;
  }

  @override
  String toString() {
    List<String> values = [
      'autoPlay=$autoPlay',
      'resumable=$resumable',
      'playerColor=$playerColor',
      'endVideoBehavior=$getEndVideoBehavior',
      'playbar=$playbar'
    ];
    return values.join(' ');
  }
}
