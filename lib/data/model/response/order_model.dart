class OrderModel {
  int _id;
  int _customerId;
  String _customerType;
  String _paymentStatus;
  OrderStatus _orderStatus;
  String _paymentMethod;
  String _transactionRef;
  double _orderAmount;
  String _shippingAddress;
  int _sellerId;
  int _shippingMethodId;
  double _shippingCost;
  String _createdAt;
  String _updatedAt;
  double _discountAmount;
  String _discountType;

  OrderModel(
      {int id,
        int customerId,
        String customerType,
        String paymentStatus,
        OrderStatus orderStatus,
        String paymentMethod,
        String transactionRef,
        double orderAmount,
        String shippingAddress,
        int sellerId,
        int shippingMethodId,
        double shippingCost,
        String createdAt,
        String updatedAt,
        double discountAmount,
        String discountType}) {
    this._id = id;
    this._customerId = customerId;
    this._customerType = customerType;
    this._paymentStatus = paymentStatus;
    this._orderStatus = orderStatus;
    this._paymentMethod = paymentMethod;
    this._transactionRef = transactionRef;
    this._orderAmount = orderAmount;
    this._shippingAddress = shippingAddress;
    this._sellerId = sellerId;
    this._shippingCost = shippingCost;
    this._shippingMethodId = shippingMethodId;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._discountAmount = discountAmount;
    this._discountType = discountType;
  }

  int get id => _id;
  int get customerId => _customerId;
  String get customerType => _customerType;
  String get paymentStatus => _paymentStatus;
  OrderStatus get orderStatus => _orderStatus;
  String get paymentMethod => _paymentMethod;
  String get transactionRef => _transactionRef;
  double get orderAmount => _orderAmount;
  String get shippingAddress => _shippingAddress;
  int get shippingMethodId => _shippingMethodId;
  int get sellerId => _sellerId;
  double get shippingCost => _shippingCost;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  double get discountAmount => _discountAmount;
  String get discountType => _discountType;

  OrderModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _customerType = json['customer_type'];
    _paymentStatus = json['payment_status'];
    _orderStatus = OrderStatus.fromJson(json['order_status']);
    _paymentMethod = json['payment_method'];
    _transactionRef = json['transaction_ref'];
    _orderAmount = json['order_amount'].toDouble();
    _shippingAddress = json['shipping_address'];
    _sellerId = json['seller_id'];
    _shippingMethodId = json['shipping_method_id'];
    _shippingCost = json['shipping_cost']?.toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _discountAmount = json['discount_amount']?.toDouble();
    _discountType = json['discount_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['customer_id'] = this._customerId;
    data['customer_type'] = this._customerType;
    data['payment_status'] = this._paymentStatus;
    data['order_status'] = this._orderStatus;
    data['payment_method'] = this._paymentMethod;
    data['transaction_ref'] = this._transactionRef;
    data['order_amount'] = this._orderAmount;
    data['shipping_address'] = this._shippingAddress;
    data['shipping_method_id'] = this._shippingMethodId;
    data['seller_id'] = this._sellerId;
    data['shipping_cost'] = this._shippingCost;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['discount_amount'] = this._discountAmount;
    data['discount_type'] = this._discountType;
    return data;
  }
}


class OrderStatus {
  int _id;
  int _position;
  String _name;
  String _displayName;
  String _description;
  String _color;

  OrderStatus({int id, int position, String name, String displayName, String description, String color});

  int get id => _id;
  int get position => _position;
  String get name => _name;
  String get displayName => _displayName;
  String get description => _description;
  String get color => _color;

  OrderStatus.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _position = json['position'];
    _name = json['name'];
    _displayName = json['display_name'];
    _description = json['description'];
    _color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['position'] = this._position;
    data['name'] = this._name;
    data['display_name'] = this._displayName;
    data['description'] = this._description;
    data['color'] = this._color;
    return data;
  }
}