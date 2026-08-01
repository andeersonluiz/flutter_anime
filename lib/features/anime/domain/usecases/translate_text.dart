import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/translation_repository.dart';

class TranslateText {
  const TranslateText(this.repository);

  final TranslationRepository repository;

  Future<Either<Failure, String>> call(TranslateTextParams params) {
    return repository.translateText(
      text: params.text,
      targetLang: params.targetLang,
    );
  }
}

class TranslateTextParams extends Equatable {
  const TranslateTextParams({
    required this.text,
    this.targetLang = 'pt',
  });

  final String text;
  final String targetLang;

  @override
  List<Object?> get props => [text, targetLang];
}
