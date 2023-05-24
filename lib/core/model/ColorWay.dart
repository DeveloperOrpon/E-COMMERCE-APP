class ColorWay {
  String name;
  String color;

  ColorWay({required this.name, required this.color});

  factory ColorWay.fromJson(Map<String, dynamic> json) {
    return ColorWay(name: json['name'], color: json['color']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "color": color,
    };
  }
}
