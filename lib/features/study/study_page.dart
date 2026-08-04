import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/dizhi.dart';
import '../../data/tiangan.dart';
import '../../data/types.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('天干地支 · 释义'),
          bottom: const TabBar(
            tabs: [Tab(text: '全部 22'), Tab(text: '天干 10'), Tab(text: '地支 12')],
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.textDim,
            indicatorColor: AppColors.accent,
            labelStyle: TextStyle(fontSize: 13),
          ),
        ),
        body: TabBarView(
          children: [
            _grid(context, [...tiangan.map((t) => ('t', t)), ...dizhi.map((d) => ('d', d))]),
            _grid(context, tiangan.map((t) => ('t', t)).toList()),
            _grid(context, dizhi.map((d) => ('d', d)).toList()),
          ],
        ),
      ),
    );
  }

  Widget _grid(BuildContext context, List<(String, Object)> items) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 4,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.85,
      children: [
        for (final it in items) _cell(context, it.$1, it.$2),
      ],
    );
  }

  Widget _cell(BuildContext context, String kind, Object item) {
    final isTg = kind == 't';
    final char = isTg ? (item as Tiangan).char : (item as Dizhi).char;
    final wx = isTg ? (item as Tiangan).wuxing : (item as Dizhi).wuxing;
    final pinyin = isTg ? (item as Tiangan).pinyin : (item as Dizhi).pinyin;
    return GestureDetector(
      onTap: () => _showDetail(context, kind, item),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSoft, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(char, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.wuxing(wx.label))),
            const SizedBox(height: 4),
            Text(pinyin, style: TextStyle(fontSize: 11, color: AppColors.textDim)),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, String kind, Object item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: MediaQuery.of(context).padding.bottom + 20,
        ),
        child: _Detail(kind: kind, item: item),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.kind, required this.item});
  final String kind;
  final Object item;

  @override
  Widget build(BuildContext context) {
    final isTg = kind == 't';
    final char = isTg ? (item as Tiangan).char : (item as Dizhi).char;
    final wx = isTg ? (item as Tiangan).wuxing : (item as Dizhi).wuxing;
    final e = isTg ? (item as Tiangan).etymology : (item as Dizhi).etymology;
    final imagery = isTg ? (item as Tiangan).imagery : '';
    final memory = isTg ? (item as Tiangan).memory : (item as Dizhi).memory;
    final dz = isTg ? null : item as Dizhi;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: Container(width: 38, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(char, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: AppColors.wuxing(wx.label))),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imagery.isNotEmpty)
                    Text(imagery, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  if (dz != null) ...[
                    Text('${dz.animal} · ${dz.season.label}季 · ${dz.hour}',
                        style: TextStyle(fontSize: 13, color: AppColors.textSoft)),
                    Text('${dz.category.label} · 藏 ${dz.canggan.map((c) => c.stem).join()}',
                        style: TextStyle(fontSize: 12, color: AppColors.textDim)),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _row('说文', e.shuowen),
        _row('字形', e.guhu),
        _row('本义', e.benyi),
        _row('为何选用', e.whyChosen),
        _row('记忆', memory, accent: true),
      ],
    );
  }

  Widget _row(String title, String body, {bool accent = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('【$title】', style: TextStyle(fontSize: 12, color: AppColors.textDim)),
          const SizedBox(height: 4),
          Text(body,
              style: TextStyle(fontSize: 14, height: 1.6, color: accent ? AppColors.accent : AppColors.text)),
        ],
      ),
    );
  }
}
