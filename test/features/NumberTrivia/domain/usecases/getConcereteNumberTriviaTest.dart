import 'package:clean_architecture_sample/features/NumberTrivia/domain/entities/NumberTrivia.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/repo/NumberTriviaRepository.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: "test");

  test('should get trivia for the number from repository', () async{
    //arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((realInvocation) async => Right(tNumberTrivia));
    //act
    final result = await usecase(Params(number: tNumber));
    //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
