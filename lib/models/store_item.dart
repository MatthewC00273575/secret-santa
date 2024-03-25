class Item {
  String name;
  String price;
  String imagePath;
  String rating;

  Item(
      {required this.name,
      required this.price,
      required this.imagePath,
      required this.rating});

  String get _name => name;
  String get _price => price;
  String get _imagePath => imagePath;
  String get _rating => rating;
}
