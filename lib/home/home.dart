import 'package:acueducto_cli/home/person.dart';
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
  List<Person> data = [];
  List<Person> filteredData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    final List<Person> items = snapshot.docs.map((doc) {
      return Person.fromJson(doc.data());
    }).toList();

    setState(() {
      data = items;
      filteredData = items;
    });
  }

  void saveCounter(int value, int index) async {
    try {
      final personId = data[index].id;
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

  void search(String query) {
    final List<Person> filteredList = data.where((person) {
      return person.name.toLowerCase().contains(query.toLowerCase()) ||
          person.id.toString().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredData = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Aplicación'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o ID',
              ),
              onChanged: (value) {
                search(value);
              },
            ),
          ),
          Expanded(
            child: filteredData.isEmpty
                ? const Center(
                    child: SpinKitCubeGrid(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(filteredData[index].name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonDetailsScreen(
                                person: filteredData[index],
                                onSave: (value, person) {
                                  saveCounter(value, index);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
