import 'package:clean_architecture_sample/core/error/failures.dart';
import 'package:clean_architecture_sample/core/usecases/usecase.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/entities/NumberTrivia.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/repo/NumberTriviaRepository.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams>{
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
