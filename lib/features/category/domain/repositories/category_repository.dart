import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getTrendingCategories(
      {int limit = 20});
  Future<Either<Failure, List<Category>>> getAllCategories(
      {int offset = 0, int limit = 20});
}
