class ProductModels {
  final int id;
  final String title;
  final String description;
  final String category;
  final String image;

  ProductModels({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
  });

  factory ProductModels.fromJson(Map<String, dynamic> json) {
    return ProductModels(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      image: json['image'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'image': image,
    };
  }
}
