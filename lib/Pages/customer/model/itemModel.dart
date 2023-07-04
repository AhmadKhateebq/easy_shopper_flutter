class ItemModel {
  int? id;
  String? name, brand, category, description, imageUrl;
  ItemModel(int? id, String? name, String? brand, String? category, String? description, String ? imageUrl) {
    this.id = id;
    this.name = name;
    this.brand = brand;
    this.category = category;
    this.description = description;
    this.imageUrl = imageUrl;
  }
  
}
