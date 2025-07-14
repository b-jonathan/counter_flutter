class Counter {
  final int id;
  final String name;
  int count;

  Counter({required this.id, required this.name, this.count = 0});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'count': count,
  };

  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
    id: json['id'],
    name: json['name'],
    count: json['count'],
  );
}