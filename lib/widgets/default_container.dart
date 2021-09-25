import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultContainer extends StatelessWidget {
  const DefaultContainer({
    Key? key,
    required this.title,
    this.actions = const [],
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  final Text title;
  final List<Widget> actions;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Get.theme.colorScheme;
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    Widget leading = const SizedBox();
    if (canPop) leading = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        icon: const _BackButtonIcon(),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
    );

    return Scaffold(
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              const Color(0xFF8E6A86),
              const Color(0xFF55506E),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.18, 0.7, 0.9],
            tileMode: TileMode.clamp,
          ),
        ),
        padding: const EdgeInsets.only(top: 40),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: canPop ? 0 : 24, right: 24),
                child: DefaultTextStyle(
                  style: Get.theme.primaryTextTheme.headline4!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Color(0xCCFFFFFF),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      leading,
                      Expanded(child: title),
                      ...actions,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButtonIcon extends StatelessWidget {
  /// Creates an icon that shows the appropriate "back" image for
  /// the current platform (as obtained from the [Theme]).
  const _BackButtonIcon({ Key? key }) : super(key: key);

  /// Returns the appropriate "back" icon for the given `platform`.
  static IconData _getIconData(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icons.arrow_back_rounded;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icons.arrow_back_ios_rounded;
    }
  }

  @override
  Widget build(BuildContext context) => Icon(_getIconData(Theme.of(context).platform));
}