class Person {
  Person({
    required this.id,
    required this.name,
    required this.email,
    required this.counters, // Hace que la lista de contadores sea nullable
    required this.mes,
    required this.valor,
    required this.n_contrato,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      counters: List<int>.from(json['counters'] ?? []),
      mes: json['mes'] ?? '',
      valor: json['valor'] ?? '',
      n_contrato: json['n_contrato'] ?? '',
    );
  }

  late List<int> counters;
  final String email;
  final String id;
  final String name;
  final String mes;
  final String valor;
  final String n_contrato;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'counters': counters,
      'mes': mes,
      'valor': valor,
      'n_contrato': n_contrato,
    };
  }
}
