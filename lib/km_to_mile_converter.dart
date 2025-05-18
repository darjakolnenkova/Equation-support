import 'package:flutter/material.dart';
import 'controller.dart';

class KmToMileConverterScreen extends StatefulWidget {  // экран для конвертации км в мили
  const KmToMileConverterScreen({Key? key}) : super(key: key);

  @override
  State<KmToMileConverterScreen> createState() => _KmToMileConverterScreenState();
}

class _KmToMileConverterScreenState extends State<KmToMileConverterScreen> {
  final TextEditingController _kmController = TextEditingController();
  double? _miles;    // переменная для хранения результата конвертации
  final controller = KmMileConverterController();  // Инициализация контроллера

  void _convert() async {
    final km = double.tryParse(_kmController.text);
    if (km != null) {
      final result = await controller.convertKmToMiles(km);
      setState(() {
        _miles = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'Конвертация: км в мили'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),  // отступы
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // выравнивание по левому краю
          children: [
            const Text(
              'Количество километров:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),   // отступ между текстом и полем ввода
            TextField(
              controller: _kmController,
              keyboardType: TextInputType.number,  // возможно ввести только числа
              decoration: const InputDecoration(
                hintText: 'Введите число...',   // "подсказка" в поле ввода :)
                border: OutlineInputBorder(),   // рамка
              ),
              style: const TextStyle(fontSize: 18),  // текст в поле ввода
            ),
            const SizedBox(height: 20),  // отступ между полем ввода и кнопкой
            SizedBox(
              child: ElevatedButton(   // кнопка для конвертации
                onPressed: _convert,  // вызов метода конвертации при нажатии
                child: const Text(
                  'Конвертировать в мили',   // текст на кнопке
                  style: TextStyle(fontSize: 18),  // размер текста на кнопке
                ),
              ),
            ),
            const SizedBox(height: 24),   // отступ после кнопки
            if (_miles != null)     // показ результата, если конвертация завершена
              Text(
                'Результат: ${_miles!.toStringAsFixed(3)} миль',  // 3 знака после запятой
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}