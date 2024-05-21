class Category {
  final String name;
  final String image;

  Category({
    required this.name,
    required this.image,
  });
}

List<Category> categoryComponents = [
  Category(name: "Pantai", image: "images/beach.png"),
  Category(name: "Gunung", image: "images/ic_gunung.png"),
  Category(name: "Danau", image: "images/lake.png"),
  Category(name: "Perkotaan", image: "images/city.png"),
];
