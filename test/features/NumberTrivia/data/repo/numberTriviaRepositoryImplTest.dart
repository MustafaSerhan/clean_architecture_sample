import 'package:clean_architecture_sample/core/error/exception.dart';
import 'package:clean_architecture_sample/core/error/failures.dart';
import 'package:clean_architecture_sample/core/network/networkInfo.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/data/datasources/numberTriviaLocalDataSource.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/data/datasources/numberTriviaRemoteDataSource.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/data/model/numberTriviaModel.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/data/repo/numberTriviaRepositoryImpl.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/entities/NumberTrivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body){
    group('device is online', ()
    {
      // This setUp applies only to the 'device is online' group
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body){
    group('device is offline', ()
    {
      // This setUp applies only to the 'device is online' group
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: "test triva");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("should check the device is online", () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivia));
        },
      );

      test(
        'should return Server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );

    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
            () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should return Cache failure when there is no cached data present',
            () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );

    });

  });


  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: "test triva");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("should check the device is online", () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getRandomNumberTrivia();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivia));
        },
      );

      test(
        'should return Server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );

    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
            () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should return Cache failure when there is no cached data present',
            () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );

    });

  });

}
