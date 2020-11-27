import 'package:clean_architecture_sample/core/util/inputConverter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter converter;

  setUp(() {
    converter = InputConverter();
  });

  group("stringToUnsignedInteger", () {

    test(
        "should return an integer when the string represent an unsigned integer",
        () {
          //Arrange
          final str = "123";
          //Act
          final result = converter.stringToUnsignedInteger(str);
          //Assert
          expect(result, Right(123));
    });

    test(
        "should throw an InvalidInputFailure when the string is not an Integer",
            () {
          //Arrange
          final str = "asd";
          //Act
          final result = converter.stringToUnsignedInteger(str);
          //Assert
          expect(result, Left(InvalidInputFailure()));
        });

    test(
        "should throw an InvalidInputFailure when the string is a negative integer",
            () {
          //Arrange
          final str = "-123";
          //Act
          final result = converter.stringToUnsignedInteger(str);
          //Assert
          expect(result, Left(InvalidInputFailure()));
        });

  });
}
