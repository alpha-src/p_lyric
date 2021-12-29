import 'package:flutter_test/flutter_test.dart';
import 'package:p_lyric/services/song_data_filter.dart';

void main() {
  test("Bugs lyrics scraper title and artist filtering test", () {
    // TEST CASE
    // 1. REMEDY(피처링:청하(CHUNG HA)) - 창모(CHANGMO) → REMEDY - 창모
    // 2. 달려 - 염따, 더 콰이엇(The Quiett), 팔토알토 및 사이먼 도미닉 및 딥플로우(Deepflow) → 달려 - 염따
    // 3. Worth It(피처링: Kid Ink) - Fifth Harmony(피프스 하모니) → Worth It - Fifth Harmony
    // 4. 비행운 Contrail - 문문(MoonMoon) → 비행운 - 문문
    final List<String> testTitle = [
      "REMEDY(피처링:청하(CHUNG HA))",
      "달려",
      "Worth It(피처링: Kid Ink)",
      "비행운 Contrail",
      "That's What I Like",
      "111%"
    ];
    final List<String> testArtist = [
      "창모(CHANGMO)",
      "염따, 더 콰이엇(The Quiett), 팔토알토 및 사이먼 도미닉 및 딥플로우(Deepflow)",
      "Fifth Harmony(피프스 하모니)",
      "문문(MoonMoon)",
      "브루노 마스",
      "도끼 Dok2",
      "pH-1"
    ];

    final List<String> filterTitle = [
      "REMEDY",
      "달려",
      "Worth It",
      "비행운",
      "That's What I Like",
      "111%"
    ];
    final List<String> filterArtist = [
      "창모",
      "염따",
      "Fifth Harmony",
      "문문",
      "브루노 마스",
      "도끼",
      "pH-1"
    ];

    int index = 0;
    for (final song in testTitle) {
      expect(song.filterSongTitle(), filterTitle[index++]);
    }

    index = 0;
    for (final artist in testArtist) {
      expect(artist.filterSongArtist(), filterArtist[index++]);
    }
  });
}
