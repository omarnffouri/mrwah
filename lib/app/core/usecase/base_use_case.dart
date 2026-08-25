import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

abstract class BaseUseCase<Type, Params> {
  Future<Either<Type, Failure>> call(Params params);
}

abstract class StreamBaseUseCase<T, Parameters> {
  Stream<T> call(Parameters parameters);
}

class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson() {
    return {};
  }
}
