class Tempat {
  final int id;
  final String title;
  final String location;
  final String star;
  final String description;
  final String type;
  final String imageAsset;
  final List<String> imageUrls;
  bool isFavorite;
  bool isSelected;

  Tempat({
    required this.id,
    required this.title,
    required this.location,
    required this.star,
    required this.description,
    required this.type,
    required this.imageAsset,
    required this.imageUrls,
    required this.isFavorite,
    required this.isSelected
  });
}