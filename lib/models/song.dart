class Song {
  String? songURL;
  String? title;
  String? artist;
  String lyrics = "";

  Song({
    required this.songURL,
    required this.artist,
    required this.title,
    required this.lyrics,
  });

  Song.fromGenius(Map<String, dynamic> json) {
    this.songURL = json['response']['hits'][0]['result']['url'];
    this.title = json['response']['hits'][0]['result']['full_title'];
    this.artist = json['response']['hits'][0]['result']['artist_names'];
    this.lyrics = "";
  }

  Song.fromBugs(String title, String artist) {
    this.songURL = _getBugsSongUrl(title, artist);
    this.artist = artist;
    this.title = title;
    this.lyrics = "";
  }
}

/// [title], [arist] 형식으로 검색 페이지의 URL을 얻는다.
///
/// 중복된 노래 제목이 존재하므로 `제목, 가수명`으로 검색하는 것이다.
/// (ex. 고백 - 10cm / 고백 - 뜨거운 감자)
String _getBugsSongUrl(String title, String artist) {
  final uri = title + ", " + artist;

  String searchQuery = Uri.encodeFull(uri).toString();

  return 'https://music.bugs.co.kr/search/track?q=$searchQuery';
}