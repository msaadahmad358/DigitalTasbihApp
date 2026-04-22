class TasbihItem {
  final String id;
  final String name;
  final String arabic;
  int count;
  int target;
  final bool isDefault;

  TasbihItem({
    required this.id,
    required this.name,
    required this.arabic,
    this.count = 0,
    this.target = 33,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'arabic': arabic,
    'count': count,
    'target': target,
    'isDefault': isDefault,
  };

  factory TasbihItem.fromJson(Map<String, dynamic> json) => TasbihItem(
    id: json['id'],
    name: json['name'],
    arabic: json['arabic'],
    count: json['count'] ?? 0,
    target: json['target'] ?? 33,
    isDefault: json['isDefault'] ?? false,
  );
}
