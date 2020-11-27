import 'package:clean_architecture_sample/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable{
  NoParams(){}
  @override
  List<Object> get props => [];
}