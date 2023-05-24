class ProductSize {
  String size;
  String name;

  ProductSize({required this.size, required this.name});

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(size: json['size'], name: json['name']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{"name": name, "size": size};
  }
}
