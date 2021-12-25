class SongDataPreprocessor {
  static RegExp _korean = RegExp(r"^[가-힣 ]*$");
  static RegExp _english = RegExp(r"^[A-Za-zÀ-ȕ ]*$");
  static RegExp _special = RegExp(r"^[0-9,_.\'\+%!@#$&?\-\ ]*$");

  static bool _isStartWithKorean(String title) {
    bool ret;
    ret = _korean.hasMatch(title.split("")[0]) ? true : false;

    return ret;
  }

  /// 영어와 한국어가 섞여 있을 경우, 첫 단어를 기준으로 그에 맞는 언어로만 구성된 `String` 을 리턴
  static String _divideLanguage(String target) {
    final bool isKorean = _isStartWithKorean(target);
    String korExtract = "";
    String engExtract = "";

    List<String> words = target.split("");

    for (final word in words) {
      if (word == " " || _special.hasMatch(word)) {
        korExtract += word;
        engExtract += word;
        continue;
      }

      if (isKorean) {
        if (_english.hasMatch(word)) break;
        korExtract += word;
      } else {
        if (_korean.hasMatch(word)) break;
        engExtract += word;
      }
    }

    return isKorean ? korExtract : engExtract;
  }

  /// 노래 제목을 벅스 검색에 최적화된 `filteredTitle` 을 반환한다.
  static String filterSongTitle(String title) {
    String filteredTitle = "";

    filteredTitle = title.split("(피처링")[0];
    filteredTitle = filteredTitle.split("(")[0];
    filteredTitle = filteredTitle.split("[")[0];

// 제목에 영어와 한국어 모두 포함되어있을 때
    if (!_korean.hasMatch(filteredTitle) && !_english.hasMatch(filteredTitle))
      filteredTitle = _divideLanguage(title);

    return filteredTitle.trim();
  }

  /// 벅스 검색에 최적화 된 가수명 필터링 함수이다.
  ///
  /// `artist` 값을 전처리를 진행하여 벅스에서 검색될 수 있는 정보만 필터링해온다.
  /// 이때 가수명에 콤마와 `및` 이 포함된 경우는 `split`을 통해 앞에 있는 정보만 가져온다.
  /// 또한 괄호안에 가수의 영문을 써놓는 경우 제외시킨다.
  /// 위의 과정을 거쳐도 한글과 영문이 혼용되있을 경우도 마지막으로 필터링한다.
  static String filterArtist(String artist) {
    String filteredArtist = "";

    filteredArtist = artist.split(", ")[0];
    filteredArtist = filteredArtist.split(" 및")[0];
    filteredArtist = filteredArtist.split("(")[0];

    if (!_korean.hasMatch(filteredArtist) && !_english.hasMatch(filteredArtist))
      filteredArtist = _divideLanguage(filteredArtist);

    return filteredArtist.trim();
  }
}
