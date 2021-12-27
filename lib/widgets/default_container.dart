import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:p_lyric/provider/ad_state.dart';

class DefaultContainer extends StatefulWidget {
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
  State<DefaultContainer> createState() => _DefaultContainerState();
}

class _DefaultContainerState extends State<DefaultContainer> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Get.find<AdState>();
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.bannerAdListener,
        )..load();
      });
    });
  }

  @override
  void dispose() {
    banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Get.theme.colorScheme;
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    Widget leading = const SizedBox();
    if (canPop)
      leading = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          icon: const _BackButtonIcon(),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      );

    return Container(
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
      child: Column(
        children: [
          Expanded(
            child: Scaffold(
              floatingActionButton: widget.floatingActionButton,
              floatingActionButtonLocation: widget.floatingActionButtonLocation,
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: canPop ? 0 : 24, right: 24),
                      child: DefaultTextStyle(
                        style: Get.theme.primaryTextTheme.headline4!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Color(0xCCFFFFFF),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            leading,
                            Expanded(child: widget.title),
                            ...widget.actions,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(child: widget.body),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: banner != null ? AdSize.banner.height.toDouble() : 0,
            child: banner != null ? AdWidget(ad: banner!) : null,
          ),
        ],
      ),
    );
  }
}

class _BackButtonIcon extends StatelessWidget {
  /// Creates an icon that shows the appropriate "back" image for
  /// the current platform (as obtained from the [Theme]).
  const _BackButtonIcon({Key? key}) : super(key: key);

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
  Widget build(BuildContext context) =>
      Icon(_getIconData(Theme.of(context).platform));
}
