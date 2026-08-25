class Brand {
  final int id;
  final String name, logo;

  const Brand({required this.id, required this.name, required this.logo});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
    );
  }
}
