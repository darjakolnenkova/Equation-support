import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'km_to_mile_converter.dart';
import 'calculator_model.dart';
import 'controller.dart';
import 'history_screen.dart';
import 'database.dart';


class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorUI(), // открывается экран калькулятора
    );
  }
}

class CalculatorUI extends StatefulWidget {                         // экран калькулятора
  const CalculatorUI({super.key});

  // состояние сохраняется при действиях
  @override
  _CalculatorUIState createState() => _CalculatorUIState();
}

// логика и состояние экрана
class _CalculatorUIState extends State<CalculatorUI> {
  String display = '0';  // то, что видит пользователь на экране
  late KmMileConverterController controller; // контроллер для экрана конвертации

  final List<String> buttons = const [     // кнопки калькулятора
    '7', '8', '9', '/',
    '4', '5', '6', 'x',
    '1', '2', '3', '-',
    'C', '0', '=', '+',
  ];

  @override
  void initState() {                                // инициализация контроллера
    super.initState();
    controller = KmMileConverterController();
  }

  Future<void> buttonPressed(String buttonText) async {     // логика нажатия на кнопку
    if (buttonText == 'C') {      // если нажата C — очистить экран
      setState(() {
        display = '0';
      });
    } else if (buttonText == '=') {     // если нажато равно — вычисление выражения
      final expression = display;
      try {
        final result = _evaluate(expression);   // считает результат

        String resultStr;       // форматирование результата
        if (result % 1 == 0) {
          resultStr = result.toInt().toString();    // без дробей
        } else {
          resultStr = result.toStringAsFixed(8).replaceFirst(RegExp(r'\.?0+$'), '');  // округляет до 8 знаков
        }                                                                             // и убирает лишние нули

        // сохранение вычислений в базу
        final timestamp = DateTime.now().toIso8601String();
        final record = CalculationRecord(
          expression: expression,
          result: resultStr,
          timestamp: timestamp,
        );

        await DatabaseHelper.instance.insertRecord(record);   // сохранение

        setState(() {
          display = resultStr;      // показывает результат
        });
      } catch (e) {     // если ошибка при расчете
        setState(() {
          display = "Ошибка";
        });
      }
    } else {     // любая другая кнопка (цифра/оператор)
      setState(() {
        display = display == '0' ? buttonText : display + buttonText;
      });
    }
  }

  // функция расчёта выражения
  double _evaluate(String expression) {
    try {
      String parsedExpression = expression.replaceAll('x', '*'); // замена x на *
      final parser = ShuntingYardParser(); // создание парсера — он будет разбирать выражение
      final exp = parser.parse(parsedExpression); // парсинг
      final cm = ContextModel(); // контекст (переменные, если есть)
      return exp.evaluate(EvaluationType.REAL, cm); // результат
    } catch (e) {
      throw Exception("Ошибка"); // при ошибке
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(                                        // -- ui приложения
      appBar: AppBar(title: const Text('Калькулятор')),
      body: SingleChildScrollView(                          // экран с результатом
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,  // верхняя часть экрана
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: Text(
                  display,
                  style: const TextStyle(fontSize: 56),
                ),
              ),
            ),
            GridView.builder(      // сетка кнопок
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),  // не скроллится
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),  // 4 кнопки в ряд
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () => buttonPressed(buttons[index]),  // при нажатии
                    child: Text(
                      buttons[index],
                      style: const TextStyle(fontSize: 35),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),     // кнопка для перехода на экран конвертации
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
            const SizedBox(height: 10),   // кнопка для перехода на экран истории
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
