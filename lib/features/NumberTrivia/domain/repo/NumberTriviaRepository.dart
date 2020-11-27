import 'package:clean_architecture_sample/core/error/failures.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/entities/NumberTrivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}