import 'package:flutter/material.dart';  // подключаю нужные бибилиотеки
import 'calculator_ui.dart';

void main() => runApp(const CalculatorApp());       // запуск приложения

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);    // конструктор

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();

    return MaterialApp(   // настраиваю внешний вид приложения
      title: 'Калькулятор',
      theme: ThemeData.from(
        colorScheme: base.colorScheme.copyWith(
          primary: const Color(0xFF8B4513),       // основной
          secondary: Colors.orange,         // вторичный
          surface: const Color(0xFFB55C44),       // поверхности
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