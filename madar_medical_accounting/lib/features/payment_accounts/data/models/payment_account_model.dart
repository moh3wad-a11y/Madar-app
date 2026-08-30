class PaymentAccountModel {
  final int? id;
  final String name;
  final String accountType; // cash|bank|visa|mastercard|instapay|other
  final double openingBalance;
  final double currentBalance;

  PaymentAccountModel({
    this.id,
    required this.name,
    required this.accountType,
    required this.openingBalance,
    required this.currentBalance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'account_type': accountType,
      'opening_balance': openingBalance,
      'current_balance': currentBalance,
    };
  }

  factory PaymentAccountModel.fromMap(Map<String, dynamic> map) {
    return PaymentAccountModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      accountType: map['account_type'] as String,
      openingBalance: (map['opening_balance'] as num).toDouble(),
      currentBalance: (map['current_balance'] as num).toDouble(),
    );
  }

  PaymentAccountModel copyWith({
    int? id,
    String? name,
    String? accountType,
    double? openingBalance,
    double? currentBalance,
  }) {
    return PaymentAccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      openingBalance: openingBalance ?? this.openingBalance,
      currentBalance: currentBalance ?? this.currentBalance,
    );
  }
}
