import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:p_lyric/models/song.dart';

const String baseUrl = 'https://music.bugs.co.kr/track/';

class AgeLimitException implements Exception {
  @override
  String toString() {
    return "🤔 노래 검색 에러\n성인인증이 필요한 곡입니다.";
  }
}

class SongNotFoundException implements Exception {
  @override
  String toString() {
    return "🥲 해당 곡을 찾을 수 없습니다.";
  }
}

class LyricsNotFoundException implements Exception {
  final String _title;
  final String _artist;

  LyricsNotFoundException(this._title, this._artist);

  @override
  String toString() {
    return "😵 해당 곡의 가사를 찾을 수 없습니다.\nTitle: $_title\nArtist: $_artist";
  }
}

/// searchQuery 를 통해 벅스에서 검색할 시 특수문자는 Uri.encodeFull 메소드에
/// 적용되지 않는 문제점을 아래의 함수로 해결
String encodeSpecial(String targetURI) {
  String ret = "";
  RegExp _special = RegExp(r"^[+#$&?]*$");
  List<String> words = targetURI.split("");

  for (final word in words) {
    if (word != " " && _special.hasMatch(word)) {
      switch (word) {
        case "#":
          ret += "%23";
          break;

        case "\$":
          ret += "%24";
          break;

        case "&":
          ret += "%26";
          break;

        case "+":
          ret += "%2B";
          break;

        case "?":
          ret += "%3F";
          break;
      }
    } else
      ret += word;
  }

  return ret;
}

/// 검색된 곡 중 알맞은 곡의 고유 ID 값을 받아온다.
Future<String> _getSongID(String searchedPage) async {
  try {
    final response = await http.get(
      Uri.parse(searchedPage),
    );
    dom.Document document = parser.parse(response.body);
    final elements = document.getElementsByClassName("check");

    if (elements.length == 0) return SongNotFoundException().toString();

    String songID = elements[1].children[0].attributes['value'].toString();

    return songID;
  } catch (e) {
    return '${e.toString()}';
  }
}

Future<bool> isExplicitSong(String songID) async {
  try {
    final response = await http.get(Uri.parse(baseUrl + songID));
    dom.Document document = parser.parse(response.body);
    String checkAge =
        document.getElementsByClassName('certificationGuide').first.innerHtml;
    return (checkAge.contains("19세")) ? true : false;
  } catch (e) {
    return false;
  }
}

/// 고유 ID 를 통해 해당 곡의 상세페이지를 들어가 가사를 받아온다.
///
/// replaceAll("...*", "") 부분은 팝송 중 간혹 "...*" 을 마지막에 포함시키는
/// 일종의 워터마크 같은 문자열이 있어 이 부분은 없애준다.
Future<String> getLyricsFromBugs(String title, String artist) async {
  Song returnSong = Song.fromBugs(title, artist);

  if (title == '' || artist == '') return returnSong.lyrics;

  String searchPageUrl = returnSong.songURL ?? '';
  String songID = await _getSongID(searchPageUrl);
  bool isExplicit = await isExplicitSong(songID);

  try {
    if (isExplicit) throw AgeLimitException().toString();

    final response = await http.get(Uri.parse(baseUrl + songID));
    dom.Document document = parser.parse(response.body);
    final lyricsContainer = document.getElementsByTagName('xmp');

    if (lyricsContainer.isEmpty)
      throw LyricsNotFoundException(title, artist).toString();

    returnSong.lyrics =
        lyricsContainer.first.innerHtml.toString().replaceAll("...*", "");
  } catch (e) {
    returnSong.lyrics = '${e.toString()}';
  }

  return returnSong.lyrics;
}
