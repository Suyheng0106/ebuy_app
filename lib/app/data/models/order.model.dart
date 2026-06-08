class Order {
  int? id;
  int? userId;
  int? addressId;
  String? status;
  double? total;
  int? cartId;
  String? createdAt;
  List<OrderItem>? orderItems;

  Order({this.id, this.userId, this.addressId, this.status, this.total, this.cartId, this.createdAt, this.orderItems});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    userId: json['user_id'],
    addressId: json['address_id'],
    status: json['status'],
    total: (json['total'] as num?)?.toDouble(),
    cartId: json['cart_id'],
    createdAt: json['created_at'],
    orderItems: (json['order_items'] as List?)
        ?.map((e) => OrderItem.fromJson(e))
        .toList(),
  );
}

class OrderItem {
  int? id;
  int? orderId;
  int? productId;
  int? quantity;
  double? price;
  OrderProduct? product;

  OrderItem({this.id, this.orderId, this.productId, this.quantity, this.price, this.product});

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json['id'],
    orderId: json['order_id'],
    productId: json['product_id'],
    quantity: json['quantity'],
    price: (json['price'] as num?)?.toDouble(),
    product: json['product'] != null ? OrderProduct.fromJson(json['product']) : null,
  );
}

class OrderProduct {
  int? id;
  String? name;
  String? description;
  int? price;
  String? image;

  OrderProduct({this.id, this.name, this.description, this.price, this.image});

  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: json['price'],
    image: json['image'],
  );
}