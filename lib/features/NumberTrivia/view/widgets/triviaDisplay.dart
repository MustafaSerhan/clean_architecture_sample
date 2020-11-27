import 'package:clean_architecture_sample/features/NumberTrivia/domain/entities/NumberTrivia.dart';
import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({
    Key key,
    @required this.numberTrivia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            numberTrivia.number.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  numberTrivia.text,
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}