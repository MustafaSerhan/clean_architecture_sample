import 'package:clean_architecture_sample/features/NumberTrivia/view/pages/numberTriviaPage.dart';
import 'package:flutter/material.dart';
import 'injectionContainer.dart' as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.purple,
        accentColor: Colors.purple.shade600,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NumberTriviaPage()
    );
  }
}
