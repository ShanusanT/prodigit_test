
class Product {
  int id;
  String title;
  String description;
  double price;
  String brand;
  String thumbnail;
  List<String> images;
  List<Review> reviews;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.brand,
    required this.thumbnail,
    required this.images,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      brand: json['brand'] ?? 'No Brand',
      thumbnail: json['thumbnail'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      reviews: List<Review>.from(json['reviews']?.map((rating) => Review.fromJson(rating)) ?? []),
    );
  }
}



class Review {
  int rating;


  Review({
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'] ?? 0,
    );
  }
}
