import 'package:flutter_test/flutter_test.dart';

import 'package:wistia_player/wistia_player.dart';

void main() {
  test('Converts Wistia URL to videoId', () {
    expect(WistiaPlayer.convertUrlToId('e4a27b971d'), 'e4a27b971d');
    expect(WistiaPlayer.convertUrlToId('4a27b971d'), null);
    expect(
        WistiaPlayer.convertUrlToId('http://home.wistia.com/medias/e4a27b971d'),
        'e4a27b971d');
    expect(
        WistiaPlayer.convertUrlToId(
            'http://www.home.wistia.com/medias/e4a27b971d'),
        'e4a27b971d');
    expect(
        WistiaPlayer.convertUrlToId(
            'https://home.wistia.com/medias/e4a27b971d'),
        'e4a27b971d');
    expect(WistiaPlayer.convertUrlToId('https://home.wi.st/medias/e4a27b971d'),
        'e4a27b971d');
    expect(
        WistiaPlayer.convertUrlToId('http://home.wistia.com/embed/e4a27b971d'),
        'e4a27b971d');
    expect(WistiaPlayer.convertUrlToId('https://home.wi.st/embed/e4a27b971d'),
        'e4a27b971d');
    expect(WistiaPlayer.convertUrlToId('https://home.wi.st/medias/e4a27b971d'),
        'e4a27b971d');
  });
}
