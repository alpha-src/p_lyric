import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:p_lyric/models/song.dart';
import 'package:p_lyric/constants/error_message.dart';

const String baseUrl = 'https://music.bugs.co.kr/track/';

/// searchQuery 를 통해 벅스에서 검색할 시 특수문자는 Uri.encodeFull 메소드에
/// 적용되지 않는 문제점을 아래의 함수로 해결
String encodeSpecial(String targetURI) {
  String ret = "";
  RegExp _special = RegExp(r"^[+#$&?]*$");
  List<String> words = targetURI.split("");

  //# $ & + ?
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

/// [title], [arist] 형식으로 검색 페이지의 URL을 얻는다.
///
/// 중복된 노래 제목이 존재하므로 `제목, 가수명`으로 검색하는 것이다.
/// (ex. 고백 - 10cm / 고백 - 뜨거운 감자)
String _getSearchPageUrl(String title, String artist) {
  final uri = title + ", " + artist;

  String searchQuery = Uri.encodeFull(uri).toString();
  searchQuery = encodeSpecial(searchQuery);

  return 'https://music.bugs.co.kr/search/track?q=$searchQuery';
}

/// 검색된 곡 중 알맞은 곡의 고유 ID 값을 받아온다.
Future<String> _getSongID(String searchedPage) async {
  try {
    final response = await http.get(
      Uri.parse(searchedPage),
    );
    dom.Document document = parser.parse(response.body);
    final elements = document.getElementsByClassName("check");

    if (elements.length == 0) return '곡 정보가 없습니다 😢';

    String songID = elements[1].children[0].attributes['value'].toString();

    return songID;
  } catch (e) {
    return '🤔 노래 검색 에러\n$e';
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

  String searchPageUrl = _getSearchPageUrl(title, artist);
  print(searchPageUrl);
  String songID = await _getSongID(searchPageUrl);
  bool isExplicit = await isExplicitSong(songID);

  try {
    if (isExplicit) throw AGE_ERROR;

    final response = await http.get(Uri.parse(baseUrl + songID));
    dom.Document document = parser.parse(response.body);
    final lyricsContainer = document.getElementsByTagName('xmp');

    if (lyricsContainer.isEmpty)
      // throw '가사를 찾을 수 없습니다\nTitle : $title\nArtist : $artist\n';
      throw NO_RESULT;

    returnSong.lyrics =
        lyricsContainer.first.innerHtml.toString().replaceAll("...*", "");
  } catch (e) {
    returnSong.lyrics = '🤔 노래 검색 에러\n$e';
    throw NO_RESULT;
  }

  return returnSong.lyrics;
}
