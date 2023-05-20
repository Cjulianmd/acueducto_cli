class Person {
  Person({
    required this.id,
    required this.name,
    required this.email,
    required this.apellido,
    required this.counters, // Hace que la lista de contadores sea nullable image_url
    required this.mes,
    required this.valor,
    required this.sector,
    required this.image_url,
    required this.cedula,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      apellido: json['apellido'] ?? '',
      counters: List<int>.from(json['counters'] ?? []),
      mes: json['mes'] ?? '',
      valor: json['valor'] ?? '',
      sector: json['sector'] ?? '',
      image_url: json['image_url'] ?? '',
      cedula: json['cedula'] ?? '',
    );
  }

  late List<int> counters;
  final String email;
  final String apellido;
  final String id;
  final String name;
  final String mes;
  final String valor;
  final String sector;
  final String image_url;
  final String cedula;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'counters': counters,
      'mes': mes,
      'valor': valor,
      'Sector': sector,
      'apellido': apellido,
      'image_url': image_url,
      'cedula': cedula,
    };
  }
}
