import 'package:acueducto_cli/home/person.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'detalles.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CounterData {
  final int month;
  final int number;

  CounterData(this.month, this.number);
}

class PersonDetailsScreen extends StatefulWidget {
  final Person person;
  final Function onSave;

  PersonDetailsScreen({required this.person, required this.onSave});

  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.person.counters[0];
  }

  @override
  Widget build(BuildContext context) {
    List<CounterData> counterDataList = [];
    DateTime currentDate = DateTime.now();
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    print(currentMonth);
    for (int i = widget.person.counters.length - 7;
        i < widget.person.counters.length - 1;
        i++) {
      int monthIndex = currentMonth - (widget.person.counters.length + 0 - i);
      if (monthIndex < 0) monthIndex += 12; // Manejar el cambio de año
      int diff = widget.person.counters[i];
      counterDataList.add(CounterData(monthIndex, diff));
    }
    print('${currentDate.month}: ${currentDate.year}');
//- widget.person.counters[i + 1];
    List<String> months = [
      'Dic',
      'Nov',
      'Oct',
      'Sep',
      'Ago',
      'Jul',
      'Jun',
      'May',
      'Abr',
      'Mar',
      'Feb',
      'Ene',
    ];

    List<charts.Series<CounterData, String>> seriesData = [
      charts.Series(
        id: "Contador",
        data: counterDataList.reversed.toList(),
        domainFn: (CounterData counterData, _) => months[counterData.month],
        measureFn: (CounterData counterData, _) => counterData.number,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
    ];

    const pi = 3.14159;
    double radius = 5.0;
    double area = radius * radius * pi;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${widget.person.name}'),
            Text('Email: ${widget.person.email}'),
            Text('Contador actual: $_counter'),
            Expanded(
              child: Transform.rotate(
                angle: 0,
                child: charts.BarChart(
                  seriesData,
                  animate: true,
                  vertical: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
