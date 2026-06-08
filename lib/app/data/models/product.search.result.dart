class SearchProductResult {
  String? name;
  int? categoryId;
  String? description;
  int? price;
  String? image;
  int? isActive;
  int? id;
  String? createdAt;
  String? updatedAt;

  SearchProductResult(
      {this.name,
        this.categoryId,
        this.description,
        this.price,
        this.image,
        this.isActive,
        this.id,
        this.createdAt,
        this.updatedAt});

  SearchProductResult.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    categoryId = json['category_id'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    isActive = json['is_active'];
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
