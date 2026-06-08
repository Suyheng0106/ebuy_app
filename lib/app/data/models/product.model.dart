class Product {
  List<Categories>? categories;

  Product({this.categories});

  Product.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? name;
  String? description;
  int? isActive;
  int? id;
  String? createdAt;
  String? updatedAt;
  List<Products>? products;

  Categories(
      {this.name,
        this.description,
        this.isActive,
        this.id,
        this.createdAt,
        this.updatedAt,
        this.products});

  Categories.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    isActive = json['is_active'];
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['is_active'] = this.isActive;
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? name;
  int? categoryId;
  String? description;
  int? price;
  String? image;
  int? isActive;
  int? id;
  String? createdAt;
  String? updatedAt;

  Products(
      {this.name,
        this.categoryId,
        this.description,
        this.price,
        this.image,
        this.isActive,
        this.id,
        this.createdAt,
        this.updatedAt});

  Products.fromJson(Map<String, dynamic> json) {
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
