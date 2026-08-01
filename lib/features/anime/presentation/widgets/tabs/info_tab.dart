import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/widgets/info_row.dart';
import '../../../domain/entities/anime.dart';

import 'package:animes_io/core/utils/app_localization.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_state.dart';
import '../../../../../shared/widgets/translated_text.dart';

class InfoTab extends StatelessWidget {
  const InfoTab({
    super.key,
    required this.anime,
  });

  final Anime anime;

  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'current':
        return AppLocalization.translate('anime_info.status_current');
      case 'finished':
        return AppLocalization.translate('anime_info.status_finished');
      case 'upcoming':
        return AppLocalization.translate('anime_info.status_upcoming');
      case 'tba':
        return AppLocalization.translate('anime_info.status_tba');
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildRow(
              context,
              'anime_info.status',
              _translateStatus(anime.status),
            ),
            _buildRow(
              context,
              'anime_info.episodes',
              anime.episodeCount?.toString() ?? 'N/A',
            ),
            _buildRow(
              context,
              'anime_info.size_ep',
              anime.episodeLength != null
                  ? '${anime.episodeLength} mins'
                  : 'N/A',
            ),
            _buildRow(
              context,
              'anime_info.info',
              anime.ageRating ?? 'N/A',
            ),
            _buildRow(
              context,
              'anime_info.genres',
              anime.rating?.toStringAsFixed(1) ?? 'N/A',
            ),
          ],
        );
      },
    );
  }

  Widget _buildRow(BuildContext context, String labelKey, String value) {
    final label = AppLocalization.translate(labelKey);
    return InfoRow(
      label: label,
      value: value,
      valueWidget: TranslatedText(value),
    );
  }
}
