import 'package:dartz/dartz.dart';
import 'package:mrwah/app/core/error/failures.dart';

import '../entities/article_entity.dart';

abstract class IArticlesRepository {
  Future<Either<List<Article>, Failure>> getAllMostPopularArticles(int number);
}
