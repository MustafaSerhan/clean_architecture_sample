import 'package:clean_architecture_sample/features/NumberTrivia/domain/entities/NumberTrivia.dart';
import 'package:meta/meta.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    @required text,
    @required number,
  }) : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      number: (json["number"] as num).toInt(),
      text: json["text"],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "text" :  text,
      "number" : number,
    };
  }
}
