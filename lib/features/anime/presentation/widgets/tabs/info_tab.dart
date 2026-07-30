import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/widgets/info_row.dart';
import '../../../domain/entities/anime.dart';

import 'package:animes_io/core/utils/app_localization.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_state.dart';

class InfoTab extends StatelessWidget {
  const InfoTab({super.key, required this.anime});

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            InfoRow(
                label: AppLocalization.translate('anime_info.status'),
                value: anime.status),
            InfoRow(
                label: AppLocalization.translate('anime_info.episodes'),
                value: anime.episodeCount?.toString() ?? 'N/A'),
            InfoRow(
                label: AppLocalization.translate('anime_info.size_ep'),
                value: anime.episodeLength != null
                    ? '${anime.episodeLength} mins'
                    : 'N/A'),
            InfoRow(
                label: AppLocalization.translate('anime_info.info'),
                value: anime.ageRating ?? 'N/A'),
            InfoRow(
                label: AppLocalization.translate('anime_info.genres'),
                value: anime.rating?.toStringAsFixed(1) ?? 'N/A'),
          ],
        );
      },
    );
  }
}
