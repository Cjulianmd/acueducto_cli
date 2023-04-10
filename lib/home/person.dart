class Person {
  Person({
    required this.id,
    required this.name,
    required this.email,
    required this.counters, // Hace que la lista de contadores sea nullable
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      counters: List<int>.from(json['counters'] ?? []),
    );
  }

  late List<int> counters;
  final String email;
  final String id;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'counters': counters,
    };
  }
}
