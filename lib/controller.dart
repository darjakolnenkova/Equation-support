import 'package:intl/intl.dart';
import 'database.dart';
import 'calculator_model.dart';

class KmMileConverterController {    // контроллер для конвертации км в мили и для сохранения результата
  final DatabaseHelper db = DatabaseHelper.instance;  // создание объекта для доступа к базе данных

  Future<double> convertKmToMiles(double km) async {    // метод для конвертации км в мили и сохранения в историю
    double result = km * 0.621371;  // перевод км в мили

    String expression = "$km км";  // формирование текста выражения
    String resultText = "${result.toStringAsFixed(2)} миль";  // формирует результат, округляя до 2 знаков
    String timestamp = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());  // формирует текущую дату и время в виде строки

    final record = CalculationRecord(  // создает объект записи для истории
      expression: expression,
      result: resultText,
      timestamp: timestamp,
    );
    await db.insertRecord(record);  // сохраняет запись в базу данных

    return result;  // возвращает сам числовой результат
  }

  void onEqualsPressed() {  // метод сохраняет выражение в историю
    String expression = '4 * 5';   // конкретно заданные данные (пример)
    String result = '20';

    DatabaseHelper.instance.saveCalculationToHistory(expression, result);  // сохранение в БД
  }
}
