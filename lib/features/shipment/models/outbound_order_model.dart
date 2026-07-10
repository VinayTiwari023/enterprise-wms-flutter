class OutboundOrderModel {
  final String orderNumber;
  final String customer;
  final String progressText;
  final String date;
  final String status;
  final double progress;

  OutboundOrderModel({
    required this.orderNumber,
    required this.customer,
    required this.progressText,
    required this.date,
    required this.status,
    required this.progress,
  });

  factory OutboundOrderModel.fromJson(Map<String, dynamic> json) {
    return OutboundOrderModel(
      orderNumber: json['orderNumber'] ?? '',
      customer: json['customer'] ?? '',
      progressText: json['progressText'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'customer': customer,
      'progressText': progressText,
      'date': date,
      'status': status,
      'progress': progress,
    };
  }
}
