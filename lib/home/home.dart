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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("./lib/assets/fondo1.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50.0),
                Image.asset(
                  '../lib/assets/logo.png',
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 70.0),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Ingresa el nombre con el cual estás registrado',
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
                          color: Color.fromARGB(255, 97, 97, 97), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 33, 33, 33), width: 2.0),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: 'Roboto',
                      fontSize: 16.0,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchResultScreen(query: _searchController.text),
                      ),
                    );
                  },
                  child: Text('Buscar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
