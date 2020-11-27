import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture_sample/core/error/failures.dart';
import 'package:clean_architecture_sample/core/usecases/usecase.dart';
import 'package:clean_architecture_sample/core/util/inputConverter.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/entities/NumberTrivia.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/usecases/GetRandomNumberTrivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter converter;

  NumberTriviaBloc({
    @required this.getConcreteNumberTrivia,
    @required this.getRandomNumberTrivia,
    @required this.converter,
  })  : assert(getConcreteNumberTrivia != null),
        assert(getRandomNumberTrivia != null),
        assert(converter != null),
        super(Empty());

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither = converter.stringToUnsignedInteger(event.stringNumber);

      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield Loading();
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(number: integer));

          yield* _eitherLoadedOrErrorState(failureOrTrivia);
        },
      );

    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());

      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> either) async* {
    yield either.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(numberTrivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return "Unexpected Failure";
    }
  }
}
