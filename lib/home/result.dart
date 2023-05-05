import 'package:MiAcueductoFacil/home/person.dart';
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
        title: Row(
          children: [
            SizedBox(width: 60),
            Text(
              'Resultados de búsqueda:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 60),
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
                  snapshot.error.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              );
            }

            final List<Person> data = snapshot.data!;

            return data.isEmpty
                ? Center(
                    child: Container(
                      width: 250,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 7, 125, 184),
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'no se encontraron resultados para su búsqueda.',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
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
                            data[index].apellido,
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
    if (query == null || query.isEmpty) {
      return []; // Si no hay consulta, retorna una lista vacía
    } else {
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
