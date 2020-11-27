import 'package:clean_architecture_sample/features/NumberTrivia/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (str) {
            inputStr = str;
          },
          onSubmitted: (_) {
            addConcrete();
          },
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: "Input a Number"),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: RaisedButton(
                onPressed: addConcrete,
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                child: Text("Search"),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                onPressed: addRandom,
                child: Text("Get Random"),
              ),
            ),
          ],
        )
      ],
    );
  }

  void addConcrete() {
    controller.clear();
    // BlocProvider.of<NumberTriviaBloc>(context)
    //     .add(GetTriviaForConcreteNumber(inputStr));
    context.bloc<NumberTriviaBloc>().add(GetTriviaForConcreteNumber(inputStr));
  }

  void addRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}