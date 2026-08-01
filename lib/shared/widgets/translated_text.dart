import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:animes_io/core/di/injection_container.dart';
import 'package:animes_io/features/anime/domain/usecases/translate_text.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_state.dart';

class TranslatedText extends StatefulWidget {
  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String? _translatedText;
  int _translationRequestId = 0;

  @override
  void initState() {
    super.initState();
    _checkAndTranslate();
  }

  @override
  void didUpdateWidget(covariant TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _translatedText = null;
      _translationRequestId++;
      _checkAndTranslate();
    }
  }

  void _checkAndTranslate() {
    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState is! SettingsLoaded ||
        settingsState.languageCode == 'en' ||
        widget.text.trim().isEmpty) {
      return;
    }

    unawaited(_translate(settingsState.languageCode));
  }

  Future<void> _translate(String targetLanguage) async {
    final requestId = ++_translationRequestId;
    final sourceText = widget.text;

    final result = await sl<TranslateText>()(
      TranslateTextParams(text: sourceText, targetLang: targetLanguage),
    );

    if (mounted && requestId == _translationRequestId) {
      setState(() {
        _translatedText = result.fold((_) => sourceText, (text) => text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is! SettingsLoaded) return;

        _translationRequestId++;
        _translatedText = null;

        if (state.languageCode != 'en' && widget.text.trim().isNotEmpty) {
          unawaited(_translate(state.languageCode));
        } else {
          setState(() {});
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
