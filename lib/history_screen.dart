import 'package:flutter/material.dart';
import 'database.dart';
import 'calculator_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<CalculationRecord> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await DatabaseHelper.instance.getHistory();
    setState(() {
      _history = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('История вычислений')),
      body: _history.isEmpty
          ? Center(child: Text('Истории нет.'))
          : ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          return ListTile(
            title: Text(item.expression),
            subtitle: Text('= ${item.result}'),
            trailing: Text(item.timestamp.substring(0, 16)),
          );
        },
      ),
    );
  }
}