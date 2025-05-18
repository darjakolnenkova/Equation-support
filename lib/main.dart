import 'package:flutter/material.dart';
import 'calculator_ui.dart';

void main() => runApp(const CalculatorApp());       // запуск приложения

class CalculatorApp extends StatelessWidget {       // главный виджет приложения
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {     // настройка темы и внешнего вида
    final base = ThemeData.light();

    return MaterialApp(
      title: 'Калькулятор',
      theme: ThemeData.from(
        colorScheme: base.colorScheme.copyWith(
          primary: const Color(0xFF8B4513),
          secondary: Colors.orange,
          surface: const Color(0xFFB55C44),
        ),
        textTheme: base.textTheme.copyWith(
          bodyLarge: const TextStyle(color: Color(0xFF800000)),
          bodyMedium: const TextStyle(color: Color(0xFF800000)),
        ),
      ).copyWith(
        scaffoldBackgroundColor: const Color(0xFFFFE4E1),   // цвет фона всего приложения
      ),
      home: const CalculatorUI(),  // стартовый экран - ui калькулятора
    );
  }
}
