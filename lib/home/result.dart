import 'package:MiAcueductoFacil/home/person.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            /*           Container(
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
            ),*/
            Text(
              'Resultados de búsqueda:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
                            '${data[index].name} ${data[index].apellido}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Sector:${data[index].sector}                                         Numero de Contador:${data[index].id}',
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PersonDetailsScreen(
                                  person: data[index],
                                  onSave: (value, person) {},
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
    if (query.isEmpty) {
      return []; // Si no hay consulta, retorna una lista vacía
    } else {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .get(); // Obtiene todos los documentos de la colección 'users'

      final List<Person> items =
          snapshot.docs.map((doc) => Person.fromJson(doc.data())).toList();

      // Filtra los elementos basados en la consulta de búsqueda
      final filteredList = items.where((person) {
        final cleanedQuery = query.replaceAll(
            ' ', ''); // Elimina los espacios en blanco de la consulta
        final cleanedName = person.name
            .replaceAll(' ', ''); // Elimina los espacios en blanco del nombre
        final cleanedId = person.id
            .toString()
            .replaceAll(' ', ''); // Elimina los espacios en blanco del ID

        return cleanedName.toLowerCase().contains(cleanedQuery.toLowerCase()) ||
            cleanedId.contains(cleanedQuery.toLowerCase());
      }).toList();

      filteredList
          .sort((a, b) => a.id.compareTo(b.id)); // Ordena los elementos por ID

      return filteredList;
    }
  }
}
