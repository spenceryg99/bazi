import 'package:flutter/cupertino.dart';

import '../../core/app_colors.dart';

class LargeTitleScroll extends StatelessWidget {
  const LargeTitleScroll({
    super.key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 100),
    this.bottomInset = true,
  });

  final String title;
  final List<Widget> children;
  final EdgeInsets padding;
  final bool bottomInset;

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        primaryColor: AppColors.accent,
        textTheme: CupertinoTextThemeData(
          navLargeTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
            letterSpacing: 0.37,
          ),
          navTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
            letterSpacing: -0.4,
          ),
          textStyle: TextStyle(color: AppColors.text),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(title),
            backgroundColor: AppColors.bg.withValues(alpha: 0.92),
            border: const Border(bottom: BorderSide(color: AppColors.separator, width: 0.5)),
            automaticallyImplyLeading: false,
            alwaysShowMiddle: true,
          ),
          SliverPadding(
            padding: padding,
            sliver: SliverList(delegate: SliverChildListDelegate(children)),
          ),
        ],
      ),
    );
  }
}
