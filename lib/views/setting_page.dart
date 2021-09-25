import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_lyric/provider/permission_provider.dart';
import 'package:p_lyric/widgets/default_container.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const Icon _warningIcon = const Icon(
    Icons.warning_rounded,
    color: const Color(0xFFFF8A80),
  );
  static const Icon _activatedIcon = const Icon(
    Icons.check_circle_rounded,
    color: Colors.greenAccent,
  );

  @override
  void initState() {
    super.initState();
    Get.find<PermissionProvider>().addListener(_listener, doRefresh: false);
  }

  @override
  void dispose() {
    Get.find<PermissionProvider>().removeListener(_listener);
    super.dispose();
  }

  void _listener() {}

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      title: Text('설정'),
      body: GetBuilder<PermissionProvider>(
        builder: (provider) {
          final settingList = [
            const _Subtitle('권한'),
            _ListTile(
              title: '알림 접근 허용',
              subtitle: '현재 재생중인 음악의 정보를 얻기 위해 필요한 권한입니다.',
              activated: provider.hasNotificationAccess,
              onTapped: provider.requestNotificationAccess,
              leading: getLeadingIconFrom(provider.hasNotificationAccess),
            ),
            _ListTile(
              title: '다른 앱 위에 표시',
              subtitle: '플로팅 뷰를 띄우기 위해 필요한 권한입니다.',
              activated: provider.hasSystemOverlayWindow,
              onTapped: provider.requestSystemOverlayWindow,
              leading: getLeadingIconFrom(provider.hasSystemOverlayWindow),
            ),
          ];

          return ListView.builder(
            itemCount: settingList.length,
            itemBuilder: (context, index) => settingList[index],
          );
        },
      ),
    );
  }

  Widget getLeadingIconFrom(bool activated) {
    return activated ? _activatedIcon : _warningIcon;
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle(this.label, {Key? key}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16 + 48, 12, 0, 12),
      child: Text(
        label,
        style: context.textTheme.subtitle2!.copyWith(
          color: context.theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.activated,
    required this.onTapped,
    this.leading,
  })  : assert(activated != null),
        super(key: key);

  final String title;
  final String? subtitle;
  final bool? activated;
  final VoidCallback onTapped;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(
      title,
      style: context.textTheme.subtitle1!.copyWith(
        color: Colors.white,
      ),
    );
    final subtitleWidget = subtitle == null
        ? null
        : Text(
            subtitle!,
            style: context.textTheme.bodyText2!.copyWith(
              color: Colors.white60,
              height: 1.4,
            ),
          );
    final contentPadding = const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 20,
    );

    return ListTile(
      leading: leading ?? const SizedBox(),
      contentPadding: contentPadding,
      horizontalTitleGap: 4.0,
      title: titleWidget,
      subtitle: subtitleWidget,
      onTap: onTapped,
    );
  }
}
