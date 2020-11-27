import 'dart:convert';

import 'package:clean_architecture_sample/core/error/exception.dart';
import 'package:clean_architecture_sample/features/NumberTrivia/data/model/numberTriviaModel.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

const rootUrl = "http://numbersapi.com/";

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaModelFromUrl(rootUrl + "$number");

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaModelFromUrl(rootUrl + "random");

  Future<NumberTriviaModel> _getTriviaModelFromUrl(String url) async{
    final result = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if(result.statusCode == 200){
      return NumberTriviaModel.fromJson(json.decode(result.body));
    }else {
      throw ServerException();
    }
  }
}
