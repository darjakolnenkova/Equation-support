import 'package:flutter/material.dart';
import 'database.dart';
import 'calculator_model.dart';

class HistoryScreen extends StatefulWidget {   // виджет экрана истории
  const HistoryScreen({super.key});            // StatefulWidget, потому что данные загружаются асинхронно

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {  // состояние виджета
  List<CalculationRecord> _history = [];                  // здесь будет храниться список всех записей из базы

  @override
  void initState() {         // загрузка истории при запуске
    super.initState();
    _loadHistory();          // загрузка данных при открытии экрана
  }

  Future<void> _loadHistory() async {
    final data = await DatabaseHelper.instance.getHistory();  // загрузка из базы
    setState(() {
      _history = data;  // обновление состояния
    });
  }

  @override
  Widget build(BuildContext context) {     // построение интерфейса
    return Scaffold(
      appBar: AppBar(title: Text('История вычислений')),
      body: _history.isEmpty     // содержимое экрана
          ? Center(child: Text('Истории нет.'))  // если нет записей
          : ListView.builder(  // если есть - показывает список
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          return ListTile(
            title: Text(item.expression),   // показывает выражение
            subtitle: Text('= ${item.result}'),  // и результат
            trailing: Text(item.timestamp.substring(0, 16)),  // дата и время
          );
        },
      ),
    );
  }
}
