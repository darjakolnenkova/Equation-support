class DivideByZeroException implements Exception { // класс для исключения при делении на ноль
  final String message;  // сообщение об ошибке
  DivideByZeroException([this.message = 'Деление на ноль']);  // конструктор с сообщением

  @override
  String toString() => message;  // возвращает сообщение как строку
}

class CalculatorModel { // основная модель калькулятора - выролнение вычислений
  double calculate(double a, double b, String operator) {
    switch (operator) {  // в зависимости от оператора выполняет нужную операцию
      case '+':
        return a + b;
      case '-':
        return a - b;
      case 'x':
        return a * b;
      case '/':
        if (b == 0) throw DivideByZeroException();  // проверка деления на ноль
        return a / b;
      default:
        throw FormatException("Неизвестный оператор"); // если неизвестный оператор
    }
  }
}

class CalculationRecord {  // класс для хранения 1-го вычисления: выражение, результат, дата/время
  final int? id;               // идентификатор записи (может быть null)
  final String expression;     // выражение
  final String result;         // результат
  final String timestamp;      // время вычисления в строке

  CalculationRecord({  // конструктор
    this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {  // преобразование объекта в Map для сохранения в базу данных
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp,
    };
  }

  factory CalculationRecord.fromMap(Map<String, dynamic> map) {  // создаёт объект CalculationRecord из Map
    return CalculationRecord(                                    // (например, при загрузке из базы)
      id: map['id'] as int?,
      expression: map['expression'] as String,
      result: map['result'] as String,
      timestamp: map['timestamp'] as String,
    );
  }
}
