class AdminModel {
  String id;
  String name;
  String imageUrl;
  String email;

  AdminModel(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.email});

  factory AdminModel.formMap(Map<String, dynamic> map) => AdminModel(
        id: map['id'],
        name: map['name'],
        imageUrl: map["imageUrl"],
        email: map["email"],
      );
}
