import 'package:clean_architecture_sample/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str){
    try{
      final integer = int.parse(str);
      if(integer < 0){
        return Left(InvalidInputFailure());
      } else{
        return Right(integer);
      }
    } on FormatException{
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure{

  @override
  List<Object> get props => [];
}