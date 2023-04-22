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
  late int Ncount;
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

    Ncount = widget.person.counters[0] - widget.person.counters[1];
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

    const pi = 3.14159;
    double radius = 5.0;
    double area = radius * radius * pi;

    List<charts.Series<CounterData, String>> seriesData = [
      charts.Series(
        id: "Contador",
        data: counterDataList.reversed.toList(),
        domainFn: (CounterData counterData, _) => months[counterData.month],
        measureFn: (CounterData counterData, _) => counterData.number,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        displayName: 'Número de contadores',
      ),
    ];

    final barChart = charts.BarChart(
      seriesData,
      animate: true,
      vertical: true,
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          lineStyle: charts.LineStyleSpec(
            color: charts.Color.black,
          ),
          labelStyle: charts.TextStyleSpec(
            color: charts.Color.white,
            fontFamily: 'Roboto',
            fontSize: 14,
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(
            color: charts.Color.black,
          ),
          labelStyle: charts.TextStyleSpec(
            color: charts.Color.black,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      layoutConfig: charts.LayoutConfig(
        leftMarginSpec: charts.MarginSpec.fixedPixel(30),
        topMarginSpec: charts.MarginSpec.fixedPixel(20),
        rightMarginSpec: charts.MarginSpec.fixedPixel(30),
        bottomMarginSpec: charts.MarginSpec.fixedPixel(20),
      ),
      // establece el color blanco como color de fondo del gráfico
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./lib/assets/fondo1.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: ${widget.person.name}'),
              Text('Email: ${widget.person.email}'),
              Text('Contador actual: $_counter'),
              Text('tu consumo del ultimo mes fue: $Ncount'),
              Expanded(
                child: barChart,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // centra los widgets horizontalmente
                children: [
                  Container(
                    width: 250, // establece el ancho de la imagen
                    height: 100, // establece la altura de la imagen
                    child: Image.asset(
                      './lib/assets/pse.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                      width:
                          16), // agrega un espacio horizontal entre las imágenes
                  Container(
                    width: 80, // establece el ancho de la imagen
                    height: 80, // establece la altura de la imagen
                    child: Image.asset(
                      './lib/assets/info.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
