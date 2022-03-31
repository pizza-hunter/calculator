import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/*
  Issues
  double operator crashes
  operator before first number crashes
  first number always shows decimal
  
  Improvements
  Show previous calculations
  Allow for chained calculations
*/
enum CalcOperator { plus, minus, multiply, divide, none }

class _MyHomePageState extends State<MyHomePage> {
  double _total = 0;
  double _first = 0;
  String _previousCalc = '';
  String _newNumber = '';
  var _operator = CalcOperator.none;

  void _appendNewNumber(String s) {
    setState(() {
      if (!(_newNumber.contains('.') & (s == '.'))) {
        if (_operator != CalcOperator.none) {
          _first = double.parse(_newNumber);
          _newNumber = '';
        } else {
          _newNumber += s;
        }
      }
    });
  }

  void _setOperator(String s) {
    setState(() {
      switch (s) {
        case '+':
          _operator = CalcOperator.plus;
          break;
        case '-':
          _operator = CalcOperator.minus;
          break;
        case '*':
          _operator = CalcOperator.multiply;
          break;
        case '/':
          _operator = CalcOperator.divide;
          break;
      }
    });
  }

  String getOperator(CalcOperator op) {
    switch (op) {
      case CalcOperator.plus:
        return '+';
      case CalcOperator.minus:
        return '-';
      case CalcOperator.multiply:
        return '*';
      case CalcOperator.divide:
        return '/';
      case CalcOperator.none:
        return '';
    }
  }

  void _equals() {
    setState(() {
      if (_operator == CalcOperator.plus) {
        _total = double.parse(_newNumber) + _first;
      } else if (_operator == CalcOperator.minus) {
        _total = _first - double.parse(_newNumber);
      } else if (_operator == CalcOperator.multiply) {
        _total = double.parse(_newNumber) * _first;
      } else if (_operator == CalcOperator.divide) {
        _total = _first / double.parse(_newNumber);
      }
      _previousCalc =
          '$_first ' + getOperator(_operator) + ' $_newNumber = $_total';
    });
    _total = 0;
    _newNumber = '';
    _operator = CalcOperator.none;
  }

  Widget calcNumberButton(String number) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                _appendNewNumber(number);
              },
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 10),
                  primary: Colors.grey,
                  backgroundColor: Color.fromARGB(255, 228, 228, 228)),
              child: Text(
                number,
                style: Theme.of(context).textTheme.headline5,
              ))
        ],
      ),
    );
  }

  Widget calcOperatorButton(String operator) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                _setOperator(operator);
              },
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 10),
                  primary: Colors.grey,
                  backgroundColor: Color.fromARGB(255, 228, 228, 228)),
              child: Text(
                operator,
                style: Theme.of(context).textTheme.headline5,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0'];
    List operators = ['+', '-', '*', '/'];
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
              color: Colors.white70,
              child: Text(
                _previousCalc,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
              color: Colors.white70,
              child: Text(
                _newNumber,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 2.6,
                padding: const EdgeInsets.all(10.0),
                children: [
                  for (var i = 0; i < numbers.length; i++)
                    calcNumberButton(numbers[i]),
                  for (var i = 0; i < operators.length; i++)
                    calcOperatorButton(operators[i])
                ]),
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 10),
                          primary: Colors.grey,
                          minimumSize: Size(335, 10),
                          backgroundColor: Color.fromARGB(255, 228, 228, 228)),
                      onPressed: () {
                        _equals();
                      },
                      child: Text(
                        '=',
                        style: Theme.of(context).textTheme.headline5,
                      )),
                ],
              ),
              // color: Colors.blue,
            )
          ],
        ));
  }
}
