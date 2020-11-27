import 'package:clean_architecture_sample/core/usecases/usecase.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/entities/NumberTrivia.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/repo/NumberTriviaRepository.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/usecases/GetRandomNumberTrivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: "test");

  test('should get trivia from repository', () async {
    //arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => Right(tNumberTrivia));
    //act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
