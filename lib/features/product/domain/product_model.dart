class Product {
  final String id;
  final String name;
  final String image;
  final String category;    // Tambahkan ini
  final String description; // Tambahkan ini
  final String price;       // Tambahkan ini

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? 'Tanpa Nama',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toString() ?? '0',
    );
  }
}