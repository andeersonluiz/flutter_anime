import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetTrendingCategories {
  final CategoryRepository repository;

  GetTrendingCategories(this.repository);

  Future<Either<Failure, List<Category>>> call({int limit = 20}) {
    return repository.getTrendingCategories(limit: limit);
  }
}
