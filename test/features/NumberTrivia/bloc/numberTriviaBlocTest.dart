import 'package:clean_architecture_sample/core/error/failures.dart';
import 'package:clean_architecture_sample/core/usecases/usecase.dart';
import 'package:clean_architecture_sample/core/util/inputConverter.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/entities/NumberTrivia.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/usecases/GetRandomNumberTrivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      converter: mockInputConverter,
    );
  });

  test("initialState should be Empty", () {
    //Assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    // The event takes in a String
    final tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = 1;
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test('should emit [Error] when the input is invalid', () async {
      // Arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      //Assert Later
      final expected = [
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.cast(), emitsInOrder(expected));
      //Act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // Arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //Assert Later
      final expected = [
        Loading(),
        Loaded(numberTrivia: tNumberTrivia),
      ];
      expectLater(bloc.cast(), emitsInOrder(expected));
      //Act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails',
            () async {
          // Arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          //Assert Later
          final expected = [
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(bloc.cast(), emitsInOrder(expected));
          //Act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        });


    test('should emit [Loading, Error] with a proper message for the error when getting data failss',
            () async {
          // Arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          //Assert Later
          final expected = [
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(bloc.cast(), emitsInOrder(expected));
          //Act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        });

  });

  group('GetTriviaForRandomNumber', () {
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('should get data from the random use case', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
            () async {
          // Arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          //Assert Later
          final expected = [
            Loading(),
            Loaded(numberTrivia: tNumberTrivia),
          ];
          expectLater(bloc.cast(), emitsInOrder(expected));
          //Act
          bloc.add(GetTriviaForRandomNumber());
        });

    test('should emit [Loading, Error] when getting data fails',
            () async {
          // Arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          //Assert Later
          final expected = [
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(bloc.cast(), emitsInOrder(expected));
          //Act
          bloc.add(GetTriviaForRandomNumber());
        });


    test('should emit [Loading, Error] with a proper message for the error when getting data fails',
            () async {
          // Arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          //Assert Later
          final expected = [
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(bloc.cast(), emitsInOrder(expected));
          //Act
          bloc.add(GetTriviaForRandomNumber());
        });

  });
}
