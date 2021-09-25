import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:nowplaying/nowplaying.dart';
import 'package:p_lyric/widgets/permission_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

/// 권한을 요청하며 특정 권한이 허가되어 있는지 저장하고 있다.
///
/// **자동으로 권한 상태가 업데이트 되려면 [addListener]를 통해 리스너를 등록해야 한다.**
/// 등록하면 앱이 [AppLifecycleState.resumed]될 때 마다 [_refresh] 함수를 호출하여
/// 권한들이 허가되어 있는지 갱신한다.
///
/// 계속해서 [_refresh] 함수가 작동하지 않도록 **뷰 위젯이 `dispose`될 때 [removeListener]를 반드시 호출해야 한다.**
class PermissionProvider extends GetxController with WidgetsBindingObserver {
  static const String alreadyRequestedKey = 'permission.alreadyRequested';

  bool get hasAll => _hasNotificationAccess && _hasSystemAlertWindow;

  bool _hasNotificationAccess = false;
  bool get hasNotificationAccess => _hasNotificationAccess;

  bool _hasSystemAlertWindow = false;
  bool get hasSystemOverlayWindow => _hasSystemAlertWindow;

  @override
  void onInit() {
    super.onInit();
    _initialize();
    _bindToWidgetsBinding();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && hasListeners) _refresh();
  }

  @override
  void onClose() {
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  Disposer addListener(GetStateUpdate listener, {bool doRefresh = true}) {
    if (doRefresh) _refresh();
    return super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
  }

  void _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyRequested = prefs.getBool(alreadyRequestedKey) ?? false;

    await _refresh();
    // 앱 첫 실행시 권한을 요구하는 `BottomSheet`를 보인다.
    if (!alreadyRequested &&
        (!_hasSystemAlertWindow || !_hasNotificationAccess)) {
      await Get.bottomSheet(
        const PermissionBottomSheet(),
        isDismissible: false,
        enableDrag: false,
      );
    }
  }

  Future<bool> _bindToWidgetsBinding() async {
    if (WidgetsBinding.instance?.isRootWidgetAttached == true) {
      WidgetsBinding.instance!.addObserver(this);
      return true;
    } else {
      return Future.delayed(
          const Duration(milliseconds: 250), _bindToWidgetsBinding);
    }
  }

  Future<void> _refresh() async {
    _hasNotificationAccess = await _checkNotificationAccess();
    _hasSystemAlertWindow = await _checkSystemAlertWindow();
    update();
  }

  Future<bool> _checkNotificationAccess() async {
    return NowPlaying.instance.isEnabled();
  }

  Future<bool> _checkSystemAlertWindow() async {
    return Permission.systemAlertWindow.isGranted;
  }

  // nowPlaying 플러그인이 권한 요구 창을 성공적으로 띄웠을 때 바로 값을 반환하기 때문에 반환값이
  // `Future<void>`가 아닌 `void`이다.
  void requestNotificationAccess() async {
    NowPlaying.instance.requestPermissions(force: true);
  }

  Future<PermissionStatus> requestSystemOverlayWindow() async {
    return Permission.systemAlertWindow.request();
  }
}
