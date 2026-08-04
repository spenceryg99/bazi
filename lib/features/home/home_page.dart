import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../shared/utils/haptic.dart';
import '../challenge/challenge_page.dart';
import '../profile/profile_page.dart';
import '../quiz/quiz_page.dart';
import '../study/study_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _index = 0;

  static const _pages = <Widget>[
    StudyPage(),
    QuizPage(),
    ChallengePage(),
    ProfilePage(),
  ];

  static const _tabs = <_TabSpec>[
    _TabSpec(CupertinoIcons.book, CupertinoIcons.book_fill, '学习'),
    _TabSpec(CupertinoIcons.square_pencil, CupertinoIcons.square_pencil_fill, '答题'),
    _TabSpec(CupertinoIcons.bolt, CupertinoIcons.bolt_fill, '挑战'),
    _TabSpec(CupertinoIcons.person, CupertinoIcons.person_fill, '我的'),
  ];

  void _switch(int i) {
    if (i == _index) return;
    Haptic.select();
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: _BlurTabBar(
        index: _index,
        tabs: _tabs,
        onTap: _switch,
      ),
    );
  }
}

class _TabSpec {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _TabSpec(this.icon, this.activeIcon, this.label);
}

class _BlurTabBar extends StatelessWidget {
  const _BlurTabBar({required this.index, required this.tabs, required this.onTap});

  final int index;
  final List<_TabSpec> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xCC1C1C1E),
            border: Border(top: BorderSide(color: AppColors.separator, width: 0.5)),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 49,
              child: Row(
                children: [
                  for (int i = 0; i < tabs.length; i++)
                    Expanded(child: _item(i, tabs[i])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(int i, _TabSpec t) {
    final on = i == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(i),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            on ? t.activeIcon : t.icon,
            size: 24,
            color: on ? AppColors.accent : AppColors.textTertiary,
          ),
          const SizedBox(height: 3),
          Text(
            t.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: on ? FontWeight.w600 : FontWeight.w400,
              color: on ? AppColors.accent : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
