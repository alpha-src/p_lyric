import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nowplaying/nowplaying.dart';
import 'package:p_lyric/services/bugs_lyrics_scraper.dart';
import 'package:p_lyric/widgets/default_snack_bar.dart';
import 'utils/waiter.dart';

class MusicProvider extends GetxController {
  /// 현재 재생되고 있는 트랙을 반환한다.
  NowPlayingTrack get track => _track.value;
  Rx<NowPlayingTrack> _track = NowPlayingTrack.notPlaying.obs;

  /// 현재 재생되고 있는 트랙의 가사를 반환한다.
  String get lyric => _lyric;
  String _lyric = "";

  /// 음악 플레이어의 상태를 반환한다.
  NowPlayingState get trackState => _trackState;
  NowPlayingState _trackState = NowPlayingState.stopped;

  bool get areLyricsUpdating => _gettingLyricsFutures.isNotEmpty;

  /// 가사를 얻고있는 [Future] 함수들의 [Set]이다.
  Set<String?> _gettingLyricsFutures = {};

  bool get enableLyricsUpdating => _enableLyricsUpdating;
  set enableLyricsUpdating(bool state) {
    _enableLyricsUpdating = state;
    if (_track.value.artist?.isNotEmpty ?? false) _updateLyric(_track.value);
  }

  bool _enableLyricsUpdating = true;

  @override
  void onInit() {
    super.onInit();
    NowPlaying.instance.stream.listen(_listenTrackEvent);
    wait(_track, _updateLyric, time: const Duration(milliseconds: 1000));
  }

  void _updateLyric(NowPlayingTrack track) async {
    if (!_enableLyricsUpdating) return;

    _lyric = await getLyricsFromBugs(
      track.title ?? '',
      track.artist ?? '',
    );

    final gettingLyricsFuture = _lyric;
    _gettingLyricsFutures.add(gettingLyricsFuture);
    update();

    _lyric = await gettingLyricsFuture;
    _gettingLyricsFutures.remove(gettingLyricsFuture);
    update();
  }

  void _listenTrackEvent(NowPlayingTrack newTrack) {
    bool updated = false;
    if (_track.value.title != newTrack.title) {
      _track.value = newTrack;
      updated = true;
    }

    if (newTrack.state != trackState) {
      _trackState = newTrack.state;
      updated = true;
    }

    if (updated) update();
  }

  /// 플레이어가 음악을 재생중인 경우 정지하며, 정지되어 있는 경우 재생한다.
  Future<void> playOrPause() async {
    try {
      await NowPlaying.instance.playOrPause(); // TODO(민성): IOS 구현
    } on PlatformException catch (e) {
      print("Failed to play or pause music: '${e.message}'.");
      _showErrorSnackBar();
    }
  }

  Future<void> skipToPrevious() async {
    try {
      await NowPlaying.instance.skipToPrevious(); // TODO(민성): IOS 구현
    } on PlatformException catch (e) {
      print("Failed to skip to previous music: '${e.message}'.");
      _showErrorSnackBar();
    }
  }

  Future<void> skipToNext() async {
    try {
      await NowPlaying.instance.skipToNext(); // TODO(민성): IOS 구현
    } on PlatformException catch (e) {
      print("Failed to skip to next music: '${e.message}'.");
      _showErrorSnackBar();
    }
  }

  void _showErrorSnackBar() {
    showSnackBar(
      '연결된 음악 플레이어가 없습니다. 음악 플레이어에서 음악을 재생해주세요.',
      duration: const Duration(seconds: 5),
    );
  }
}
