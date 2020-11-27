import 'dart:convert';

import 'package:clean_architecture_sample/core/error/exception.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/data/datasources/numberTriviaRemoteDataSource.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/data/model/numberTriviaModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixtureReader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  MockHttpClient mockHttpClient;

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

    test(
        "should preform a GET request on a URL with number being the endpoint and with application/json header",
        () async {
      //Arrange
      setUpMockHttpClientSuccess200();
      //Act
      dataSourceImpl.getConcreteNumberTrivia(tNumber);
      //Assert
      verify(mockHttpClient.get(
        'http://numbersapi.com/$tNumber',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test("should return NumberTrivia when the response code is 200 (success)",
        () async {
      //Arrange
      setUpMockHttpClientSuccess200();
      //Act
      final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);
      //Assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        "should throw a ServerException when the response code is 404 or other",
        () async {
      //Arrange
      setUpMockHttpClientFailure404();
      //Act
      final call = dataSourceImpl.getConcreteNumberTrivia;
      //Assert
      expect(() => call(tNumber), throwsA(isInstanceOf<ServerException>()));
    });
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

    test(
        "should preform a GET request on a URL with number being the endpoint and with application/json header",
            () async {
          //Arrange
          setUpMockHttpClientSuccess200();
          //Act
          dataSourceImpl.getRandomNumberTrivia();
          //Assert
          verify(mockHttpClient.get(
            'http://numbersapi.com/random',
            headers: {'Content-Type': 'application/json'},
          ));
        });

    test("should return NumberTrivia when the response code is 200 (success)",
            () async {
          //Arrange
          setUpMockHttpClientSuccess200();
          //Act
          final result = await dataSourceImpl.getRandomNumberTrivia();
          //Assert
          expect(result, equals(tNumberTriviaModel));
        });

    test(
        "should throw a ServerException when the response code is 404 or other",
            () async {
          //Arrange
          setUpMockHttpClientFailure404();
          //Act
          final call = dataSourceImpl.getRandomNumberTrivia;
          //Assert
          expect(() => call(), throwsA(isInstanceOf<ServerException>()));
        });
  });

}
