import 'dart:convert';

import 'package:clean_architecture_sample/features/NumberTrivia/data/model/numberTriviaModel.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/domain/entities/NumberTrivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixtureReader.dart';

void main(){
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test("should be a subclass of NumberTrivia", (){
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
  
  group("fromJSON", (){

    test("should return a valid model when the JSON number is an integer", (){
      //arrenge
      final Map<String, dynamic> jsonMap = json.decode(fixture("trivia.json"));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test("should return a valid model when the JSON number is regarded as a double", (){
      //arrenge
      final Map<String, dynamic> jsonMap = json.decode(fixture("triviaDouble.json"));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
          () async {
        // act
        final result = tNumberTriviaModel.toJson();
        // assert
        final expectedJsonMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result, expectedJsonMap);
      },
    );
  });
  
}