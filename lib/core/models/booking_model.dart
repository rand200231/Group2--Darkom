// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookingModel {
  final String? docId;
  final String experienceId;
  final String userId;
  final int ticketsNumber;
  final double total;
  final String paymentMethod;
  final DateTime date;

  BookingModel({
    this.docId,
    required this.experienceId,
    required this.userId,
    required this.ticketsNumber,
    required this.total,
    required this.paymentMethod,
    required this.date,
  });

  BookingModel copyWith({
    String? docId,
    String? experienceId,
    String? userId,
    int? ticketsNumber,
    double? total,
    String? paymentMethod,
    DateTime? date,
  }) {
    return BookingModel(
      docId: docId ?? this.docId,
      experienceId: experienceId ?? this.experienceId,
      userId: userId ?? this.userId,
      ticketsNumber: ticketsNumber ?? this.ticketsNumber,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'experienceId': experienceId,
      'userId': userId,
      'ticketsNumber': ticketsNumber,
      'total': total,
      'paymentMethod': paymentMethod,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String docId) {
    return BookingModel(
      docId: docId,
      experienceId: map['experienceId'] as String,
      userId: map['userId'] as String,
      ticketsNumber: map['ticketsNumber'] as int,
      total: map['total'] as double,
      paymentMethod: map['paymentMethod'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  @override
  String toString() {
    return 'BookingModel(docId: $docId, experienceId: $experienceId, userId: $userId, ticketsNumber: $ticketsNumber, total: $total, paymentMethod: $paymentMethod, date: $date)';
  }
}
