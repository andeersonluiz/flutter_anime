import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animes_io/core/di/injection_container.dart';
import 'package:animes_io/core/utils/translation_service.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_state.dart';

class TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool forceTranslate;
  final String targetLanguage;

  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.forceTranslate = false,
    this.targetLanguage = 'pt',
  });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String? _translatedText;
  bool _isTranslating = false;

  @override
  void initState() {
    super.initState();
    _checkAndTranslate();
  }

  @override
  void didUpdateWidget(covariant TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.forceTranslate != widget.forceTranslate ||
        oldWidget.targetLanguage != widget.targetLanguage) {
      _translatedText = null;
      _checkAndTranslate();
    }
  }

  void _checkAndTranslate() {
    final settingsState = context.read<SettingsBloc>().state;
    final autoTranslateEnabled =
        settingsState is SettingsLoaded && settingsState.autoTranslate;

    if ((autoTranslateEnabled || widget.forceTranslate) &&
        widget.text.trim().isNotEmpty) {
      unawaited(_translate());
    }
  }

  Future<void> _translate() async {
    if (_isTranslating) return;
    setState(() => _isTranslating = true);

    final translationService = sl<TranslationService>();
    final result = await translationService.translate(
      widget.text,
      targetLanguage: widget.targetLanguage,
    );

    if (mounted) {
      setState(() {
        _translatedText = result;
        _isTranslating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsLoaded) {
          if (state.autoTranslate && _translatedText == null) {
            unawaited(_translate());
          }
        }
      },
      child: Text(
        _translatedText ?? widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      ),
    );
  }
}
