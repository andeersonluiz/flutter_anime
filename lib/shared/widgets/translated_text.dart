import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:animes_io/core/di/injection_container.dart';
import 'package:animes_io/features/anime/domain/usecases/translate_text.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_state.dart';

class TranslatedText extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous is! SettingsLoaded ||
          current is! SettingsLoaded ||
          previous.languageCode != current.languageCode,
      builder: (context, state) {
        final languageCode =
            state is SettingsLoaded ? state.languageCode : 'en';

        if (languageCode == 'en' || text.trim().isEmpty) {
          return Text(
            text,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          );
        }

        return _TranslatedTextContent(
          key: ValueKey('$text:$languageCode'),
          text: text,
          targetLanguage: languageCode,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}

class _TranslatedTextContent extends StatefulWidget {
  const _TranslatedTextContent({
    super.key,
    required this.text,
    required this.targetLanguage,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final String targetLanguage;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  State<_TranslatedTextContent> createState() => _TranslatedTextContentState();
}

class _TranslatedTextContentState extends State<_TranslatedTextContent> {
  String? _translatedText;

  @override
  void initState() {
    super.initState();
    unawaited(_translate());
  }

  Future<void> _translate() async {
    final result = await sl<TranslateText>()(
      TranslateTextParams(
        text: widget.text,
        targetLang: widget.targetLanguage,
      ),
    );

    if (!mounted) return;
    setState(() {
      _translatedText = result.fold((_) => widget.text, (text) => text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _translatedText ?? widget.text,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
