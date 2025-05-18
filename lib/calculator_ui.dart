import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'km_to_mile_converter.dart';
import 'calculator_model.dart';
import 'controller.dart';
import 'history_screen.dart';
import 'database.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorUI(),
    );
  }
}

class CalculatorUI extends StatefulWidget {
  const CalculatorUI({Key? key}) : super(key: key);

  @override
  _CalculatorUIState createState() => _CalculatorUIState();
}

class _CalculatorUIState extends State<CalculatorUI> {
  String display = '0';
  late KmMileConverterController controller;

  final List<String> buttons = const [
    '7', '8', '9', '/',
    '4', '5', '6', 'x',
    '1', '2', '3', '-',
    'C', '0', '=', '+',
  ];

  @override
  void initState() {
    super.initState();
    controller = KmMileConverterController();
  }

  Future<void> buttonPressed(String buttonText) async {
    if (buttonText == 'C') {
      setState(() {
        display = '0';
      });
    } else if (buttonText == '=') {
      final expression = display;
      try {
        final result = _evaluate(expression);

        String resultStr;
        if (result % 1 == 0) {
          resultStr = result.toInt().toString();
        } else {
          resultStr = result.toStringAsFixed(8).replaceFirst(RegExp(r'\.?0+$'), '');
        }

        final timestamp = DateTime.now().toIso8601String();
        final record = CalculationRecord(
          expression: expression,
          result: resultStr,
          timestamp: timestamp,
        );

        await DatabaseHelper.instance.insertRecord(record);

        setState(() {
          display = resultStr;
        });
      } catch (e) {
        setState(() {
          display = "Ошибка";
        });
      }
    } else {
      setState(() {
        display = display == '0' ? buttonText : display + buttonText;
      });
    }
  }

  double _evaluate(String expression) {
    try {
      String parsedExpression = expression.replaceAll('x', '*');
      Parser p = Parser();
      Expression exp = p.parse(parsedExpression);
      ContextModel cm = ContextModel();
      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      throw Exception("Ошибка");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Калькулятор')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: Text(
                  display,
                  style: const TextStyle(fontSize: 56),
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () => buttonPressed(buttons[index]),
                    child: Text(
                      buttons[index],
                      style: const TextStyle(fontSize: 35),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const KmToMileConverterScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Конвертация: км в мили'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('История вычислений'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
