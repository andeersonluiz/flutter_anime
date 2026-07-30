import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../core/utils/app_localization.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../settings/presentation/bloc/settings_state.dart';
import '../../../domain/entities/anime.dart';
import '../../../domain/usecases/translate_synopsis.dart';

class SynopsisTab extends StatefulWidget {
  final Anime anime;

  const SynopsisTab({super.key, required this.anime});

  @override
  State<SynopsisTab> createState() => _SynopsisTabState();
}

class _SynopsisTabState extends State<SynopsisTab> {
  bool _isTranslated = false;
  bool _isLoading = false;
  String? _translatedSynopsis;
  String? _errorMessage;

  Future<void> _toggleTranslation() async {
    if (_isTranslated) {
      setState(() {
        _isTranslated = false;
        _errorMessage = null;
      });
      return;
    }

    if (_translatedSynopsis != null) {
      setState(() {
        _isTranslated = true;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final translateSynopsis = sl<TranslateSynopsis>();
    final result = await translateSynopsis(
      TranslateSynopsisParams(
        animeId: widget.anime.id,
        synopsisText: widget.anime.synopsis,
        targetLang: 'pt',
      ),
    );

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = AppLocalization.translate('errors.translate_error');
        });
      },
      (translated) {
        setState(() {
          _isLoading = false;
          _translatedSynopsis = translated;
          _isTranslated = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        final currentText = (_isTranslated && _translatedSynopsis != null)
            ? _translatedSynopsis!
            : widget.anime.synopsis;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalization.translate('anime_info.synopsis'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (_isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    TextButton.icon(
                      icon: Icon(
                        _isTranslated ? Icons.translate : Icons.g_translate,
                        size: 18,
                      ),
                      label: Text(
                        _isTranslated ? 'Original (EN)' : 'Traduzir (PT)',
                      ),
                      onPressed: _toggleTranslation,
                    ),
                ],
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Colors.amber, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                currentText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
