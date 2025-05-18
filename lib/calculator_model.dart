class DivideByZeroException implements Exception {
  final String message;
  DivideByZeroException([this.message = 'Деление на ноль']);

  @override
  String toString() => message;
}

class CalculatorModel {
  double calculate(double a, double b, String operator) {
    switch (operator) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case 'x':
        return a * b;
      case '/':
        if (b == 0) throw DivideByZeroException();
        return a / b;
      default:
        throw FormatException("Неизвестный оператор");
    }
  }
}

class CalculationRecord {
  final int? id;
  final String expression;
  final String result;
  final String timestamp;

  CalculationRecord({
    this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp,
    };
  }

  factory CalculationRecord.fromMap(Map<String, dynamic> map) {
    return CalculationRecord(
      id: map['id'] as int?,
      expression: map['expression'] as String,
      result: map['result'] as String,
      timestamp: map['timestamp'] as String,
    );
  }
}