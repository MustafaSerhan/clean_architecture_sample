import 'package:clean_architecture_sample/core/error/failures.dart';
import 'package:clean_architecture_sample/core/usecases/usecase.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/entities/NumberTrivia.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/repo/NumberTriviaRepository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}


class Params extends Equatable{
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [];
}