class Item {
  int id;
  String title;
  String detail;
  double value;
  bool flag;
  String category;

  Item({
    required this.id,
    required this.title,
    this.detail = '',
    this.value = 0,
    this.flag = false,
    this.category = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'detail': detail,
        'value': value,
        'flag': flag,
        'category': category,
      };

  factory Item.fromJson(Map<String, dynamic> j) => Item(
        id: j['id'] as int,
        title: j['title'] as String,
        detail: (j['detail'] ?? '') as String,
        value: (j['value'] ?? 0).toDouble(),
        flag: (j['flag'] ?? false) as bool,
        category: (j['category'] ?? '') as String,
      );
}
