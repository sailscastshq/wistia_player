class WistiaMetaData {
  /// Wistia video ID of the currently loaded video.
  final String videoId;

  /// Video title of the currently loaded video.
  final String title;

  /// Total duration of the currently loaded video.
  final Duration duration;

  /// Create [WistiaMetaData] for the a Wistia video.
  WistiaMetaData(
      {this.videoId = '', this.title = '', this.duration = const Duration()});

  /// Create [WistiaMetaData] from raw json
  factory WistiaMetaData.fromJson(Map<String, dynamic> data) {
    final durationInMs = (((data['duration'] ?? 0) as double) * 1000).floor();

    return WistiaMetaData(
        videoId: data['videoId'],
        title: data['title'],
        duration: Duration(milliseconds: durationInMs));
  }

  @override
  String toString() {
    return '$runtimeType('
        'videoId: $videoId, '
        'title: $title, '
        'duration: ${duration.inSeconds} sec.)';
  }
}
