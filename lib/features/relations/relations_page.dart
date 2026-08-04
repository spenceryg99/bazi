import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/dizhi_relations.dart';
import '../../shared/widgets/relation_wheel.dart';

class RelationsPage extends StatelessWidget {
  const RelationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('地支六大关系')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(child: const RelationWheel(size: 320)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('力量层级（强 → 弱）', style: TextStyle(fontSize: 13, color: AppColors.textDim, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(powerOrder, style: TextStyle(fontSize: 14, color: AppColors.accent, fontWeight: FontWeight.w500, height: 1.6)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final r in relations) _relationCard(r),
        ],
      ),
    );
  }

  Widget _relationCard(Relation r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: Color(r.color), width: 4),
        ),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          shape: const Border(),
          title: Row(
            children: [
              Text(r.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Expanded(child: Text(r.summary, style: TextStyle(fontSize: 12, color: AppColors.textDim), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          children: [
            _kv('原理', r.principle),
            _kv('力量', r.power),
            _kv('成立条件', r.condition),
            if (r.variants != null) _kv('变体', r.variants!),
            _kv('喜忌', r.xiji),
            _kv('口诀', r.koujue, accent: true),
            const SizedBox(height: 10),
            Text('配对明细', style: TextStyle(fontSize: 13, color: AppColors.textDim, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            for (final p in r.pairs) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bgElev,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(p.members.join(' + '),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        if (p.result != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text('${r.id == RelationId.liuhe ? '化' : '成'}${p.result}',
                                style: const TextStyle(fontSize: 11, color: Colors.white)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(p.meaning, style: TextStyle(fontSize: 13, color: AppColors.textSoft, height: 1.5)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v, {bool accent = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(k, style: TextStyle(fontSize: 12, color: AppColors.textDim)),
          ),
          Expanded(
            child: Text(v,
                style: TextStyle(fontSize: 13, height: 1.6, color: accent ? AppColors.accent : AppColors.text)),
          ),
        ],
      ),
    );
  }
}
