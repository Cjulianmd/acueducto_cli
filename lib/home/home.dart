import 'package:acueducto_cli/home/person.dart';
import 'package:acueducto_cli/home/result.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'detalles.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("./lib/assets/fondo1.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50.0),
                  Image.asset(
                    './lib/assets/logo.png',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 50.0),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Ingresa tu primer nombre',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 102, 102, 102),
                                  width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 97, 97, 97),
                                  width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 33, 33, 33),
                                  width: 2.0),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey[700],
                              fontFamily: 'Roboto',
                              fontSize: 16.0,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 16.0),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchResultScreen(
                                    query: _searchController.text),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            // shape: CircleBorder(),
                            padding: EdgeInsets.all(16),
                          ),
                          child: Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blue,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Acá podrás consultar:',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '-Tu consumo actual',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '-Tu consumo promedio semestral',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '-Pago de tu factura PSE',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Person>> _fetchData(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .where('id', isGreaterThanOrEqualTo: query)
        .where('id', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final List<Person> items = snapshot.docs.map((doc) {
      return Person.fromJson(doc.data());
    }).toList();

    return items;
  }

  void saveCounter(String personId, int index) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(personId);

      // Obtiene los contadores actuales del documento de Firestore
      final docSnapshot = await userRef.get();
      final counters = List<int>.from(docSnapshot.get('counters') ?? []);

      // Muestra una alerta indicando que el guardado fue exitoso
    } catch (e) {
      // Muestra una alerta indicando que el guardado ha fallado
      print(e);
    }
  }
}
