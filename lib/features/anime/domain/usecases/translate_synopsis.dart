import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/translation_repository.dart';

class TranslateSynopsis {
  final TranslationRepository repository;

  TranslateSynopsis(this.repository);

  Future<Either<Failure, String>> call(TranslateSynopsisParams params) {
    return repository.translateSynopsis(
      animeId: params.animeId,
      synopsisText: params.synopsisText,
      targetLang: params.targetLang,
    );
  }
}

class TranslateSynopsisParams extends Equatable {
  final String animeId;
  final String synopsisText;
  final String targetLang;

  const TranslateSynopsisParams({
    required this.animeId,
    required this.synopsisText,
    this.targetLang = 'pt',
  });

  @override
  List<Object?> get props => [animeId, synopsisText, targetLang];
}
