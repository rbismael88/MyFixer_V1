
import 'package:flutter/material.dart';

class Day {
  final String name;
  bool isSelected;

  Day(this.name, {this.isSelected = false});
}

class EditProviderScheduleScreen extends StatefulWidget {
  const EditProviderScheduleScreen({super.key});

  @override
  State<EditProviderScheduleScreen> createState() => _EditProviderScheduleScreenState();
}

class _EditProviderScheduleScreenState extends State<EditProviderScheduleScreen> {
  final List<Day> _days = [
    Day('Lunes', isSelected: true),
    Day('Martes', isSelected: true),
    Day('Miércoles', isSelected: true),
    Day('Jueves', isSelected: true),
    Day('Viernes', isSelected: true),
    Day('Sábado'),
    Day('Domingo'),
  ];

  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Editar Horario', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              // Save logic here
              Navigator.pop(context);
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Días de la semana', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ..._days.map((day) => CheckboxListTile(
            title: Text(day.name, style: const TextStyle(color: Colors.white)),
            value: day.isSelected,
            onChanged: (bool? value) {
              setState(() {
                day.isSelected = value ?? false;
              });
            },
            activeColor: Colors.green,
            checkColor: Colors.black,
            side: const BorderSide(color: Colors.white),
          )),
          const SizedBox(height: 24),
          const Text('Horas de trabajo', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimePicker(context, 'Desde', _startTime, (newTime) {
                setState(() {
                  _startTime = newTime;
                });
              }),
              _buildTimePicker(context, 'Hasta', _endTime, (newTime) {
                setState(() {
                  _endTime = newTime;
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, String label, TimeOfDay time, ValueChanged<TimeOfDay> onTimeChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () async {
            final newTime = await showTimePicker(context: context, initialTime: time);
            if (newTime != null) {
              onTimeChanged(newTime);
            }
          },
          child: Text(time.format(context), style: const TextStyle(color: Colors.white, fontSize: 24)),
        ),
      ],
    );
  }
}
