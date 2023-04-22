
import 'package:acueducto_cli/home/person.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'detalles.dart';

class SearchResultScreen extends StatelessWidget {
  final String query;

  const SearchResultScreen({required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Resultados de búsqueda',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./lib/assets/fondo2.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Person>>(
          future: fetchData(query),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'error al cargar los datos',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              );
            }

            final List<Person> data = snapshot.data!;

            return ListView.builder(
              itemCount: data.length,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      data[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      data[index].email,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.grey[600],
                    ),
                    onTap: () {
                      saveCounter(data[index].id, index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonDetailsScreen(
                            person: data[index],
                            onSave: (value, person) {
                              saveCounter(value, index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<Person>> fetchData(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
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
