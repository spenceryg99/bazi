import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              selectedIcon: Icon(Icons.menu_book), icon: Icon(Icons.menu_book_outlined), label: '学习'),
          NavigationDestination(
              selectedIcon: Icon(Icons.edit_note), icon: Icon(Icons.edit_note_outlined), label: '答题'),
          NavigationDestination(
              selectedIcon: Icon(Icons.bolt), icon: Icon(Icons.bolt_outlined), label: '挑战'),
          NavigationDestination(
              selectedIcon: Icon(Icons.insights), icon: Icon(Icons.insights_outlined), label: '我的'),
        ],
      ),
    );
  }
}
