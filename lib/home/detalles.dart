import 'package:MiAcueductoFacil/home/person.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:url_launcher/url_launcher.dart';

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
    String promedio;

    double pr = 0;

    if (widget.person.counters.length < 8) {
      // Obtener el último elemento de la lista
      int lastValue = widget.person.counters.last;

      // Llenar la lista con el último valor hasta alcanzar una longitud de 8
      widget.person.counters
          .addAll(List.filled(8 - widget.person.counters.length, lastValue));

      promedio = 'datos insuficientes';
    }

    //el ciclo para obtener los meses y los datos que le corresponden
    for (int i = widget.person.counters.length - 7;
        i < widget.person.counters.length - 1;
        i++) {
      int currentMonth = DateTime.now().month; // Obtener el mes actual

      int monthIndex = i - currentMonth;

      if (monthIndex < 0) monthIndex += 12; // Manejar el cambio de año

      int diff = widget.person.counters[i - 1] - widget.person.counters[i];
      if (diff > 1000) {
        diff = 0;
      }
      counterDataList.add(CounterData(monthIndex, diff));
      pr = pr + diff;
    }

    double calcular = pr / 6;
    String resultado = calcular.toStringAsFixed(2);
    promedio = '$resultado';
    Ncount = widget.person.counters[0] - widget.person.counters[1];
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
        displayName: 'Número de contadores',
      ),
    ];

    final barChart = charts.BarChart(
      seriesData,
      animate: true,
      vertical: true,
      domainAxis: charts.OrdinalAxisSpec(
        viewport:
            charts.OrdinalViewport(counterDataList.first.month.toString(), 7),
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
            color: charts.Color.white,
            fontFamily: 'Roboto',
            fontSize: 14, // Agregar el tamaño de fuente aquí
          ),
        ),
      ),
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      layoutConfig: charts.LayoutConfig(
        leftMarginSpec: charts.MarginSpec.fixedPixel(30),
        topMarginSpec: charts.MarginSpec.fixedPixel(20),
        rightMarginSpec: charts.MarginSpec.fixedPixel(30),
        bottomMarginSpec: charts.MarginSpec.fixedPixel(20),
      ),
    );
    String clientId = widget.person.id;

    // Construye la URL del archivo PDF
    // String baseUrl =$baseUrl/$fileName
    'gs://mineragro-6b792.appspot.com/facturas'; // Reemplaza con la URL base del almacenamiento

    String fileUrl =
        'https://firebasestorage.googleapis.com/v0/b/mineragro-6b792.appspot.com/o/facturas%2F$clientId.pdf?alt=media&token=5b158e4a-a23c-4a89-b5bc-c96259dd150c';
    int consumo = _counter - widget.person.counters[1];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.person.name),
            SizedBox(width: 100),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  './lib/assets/logo.png',
                  height: 30,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
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
              Text('Apellido: ${widget.person.apellido}'),
              Text('Email: ${widget.person.email}'),
              Text('Codigo: ${widget.person.id}'),
              Text('Sector: ${widget.person.sector}'),
              Text('Cedula: ${widget.person.cedula}'),
              Text('Mes de factura: ${widget.person.mes}'),
              Text('Lectura actual: $_counter'),
              Text(
                  'Lectura anterior: ${widget.person.counters.length >= 2 ? widget.person.counters[1] : 'No hay datos'}'),

              Text('Tu consumo: $consumo'),
              Text('Promedio de los últimos 6 meses: $promedio'),
              Text('Valor a pagar: ${widget.person.valor}'),
              SizedBox(height: 10),

              Row(
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (fileUrl != null) {
                          await launch(fileUrl);
                        } else {
                          print('No se pudo abrir la URL: $fileUrl');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Descarga aquí tu factura',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        launch(widget.person.image_url);
                        //launchUrl(Uri.parse('${widget.person.image_url}'));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Prueba de lectura',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Expanded(
                child: barChart,
              ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .start, // centra los widgets horizontalmente
                children: [
                  GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse(
                          'https://servicios.cotrafa.com.co/pseExterno'));
                    },
                    child: Container(
                      width: 260, // establece el ancho de la imagen
                      height: 100, // establece la altura de la imagen
                      child: Image.asset(
                        './lib/assets/pse.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                      width:
                          10), // agrega un espacio horizontal entre las imágenes
                  GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse('https://youtu.be/j3LRd9tLphA'));
                    },
                    child: Container(
                      width: 80, // establece el ancho de la imagen
                      height: 60, // establece la altura de la imagen
                      child: Image.asset(
                        './lib/assets/info.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              // establece la altura de la imagen
            ],
          ),
        ),
      ),
    );
  }
}
