import 'package:flutter/material.dart';

import '../../../../../shared/widgets/info_row.dart';
import '../../../domain/entities/anime.dart';

class InfoTab extends StatelessWidget {
  const InfoTab({super.key, required this.anime});

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        InfoRow(label: 'Status', value: anime.status),
        InfoRow(label: 'Episode Count', value: anime.episodeCount?.toString() ?? 'N/A'),
        InfoRow(label: 'Episode Length', value: anime.episodeLength != null ? '${anime.episodeLength} mins' : 'N/A'),
        InfoRow(label: 'Age Rating', value: anime.ageRating ?? 'N/A'),
        InfoRow(label: 'Rating', value: anime.rating?.toStringAsFixed(1) ?? 'N/A'),
      ],
    );
  }
}
