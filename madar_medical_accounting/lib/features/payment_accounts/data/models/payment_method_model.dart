class PaymentMethodModel {
  final int? id;
  final String name;
  final int paymentAccountId;
  final bool isActive;

  PaymentMethodModel({
    this.id,
    required this.name,
    required this.paymentAccountId,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'payment_account_id': paymentAccountId,
      'is_active': isActive ? 1 : 0,
    };
  }

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      paymentAccountId: map['payment_account_id'] as int,
      isActive: (map['is_active'] as int) == 1,
    );
  }

  PaymentMethodModel copyWith({
    int? id,
    String? name,
    int? paymentAccountId,
    bool? isActive,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      paymentAccountId: paymentAccountId ?? this.paymentAccountId,
      isActive: isActive ?? this.isActive,
    );
  }
}
