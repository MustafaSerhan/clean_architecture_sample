import 'dart:convert';

import 'package:clean_architecture_sample/core/error/exception.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/data/datasources/numberTriviaLocalDataSource.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/data/model/numberTriviaModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixtureReader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main(){
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDataSourceImpl localDataSourceImpl;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    localDataSourceImpl = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });
  
  group("getLastTriviaNumber", (){
    final triviaMap = json.decode(fixture("triviaCached.json"));
    final tNumberTriviaModel = NumberTriviaModel.fromJson(triviaMap);

    test(
        "should return NumberTrivia from SharedPreferences when there is one in the cache",
        () async {
          //Arrange
          when(mockSharedPreferences.getString(any))
              .thenReturn(fixture("triviaCached.json"));
          //Act
          final result = await localDataSourceImpl.getLastNumberTrivia();
          //Assert
          verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
          expect(result, equals(tNumberTriviaModel));
    });


    test(
        "should throw a CacheException when there is not a cached value",
            () async {
          //Arrange
          when(mockSharedPreferences.getString(any)).thenReturn(null);
          //Act
          final call = localDataSourceImpl.getLastNumberTrivia;
          //Assert
          expect(() => call(), throwsA(isInstanceOf<CacheException>()));
        });

  });

  group("cacheNumberTrivia", (){
    final tNumberTriviaModel = NumberTriviaModel(text: "test trivia", number: 1);

    test(
        "should call SharedPreferences to cache the data",
            () async {
          localDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
          //Assert
          final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
          verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
          //expect(, throwsA(isInstanceOf<CacheException>()));
        });


  });
  
}