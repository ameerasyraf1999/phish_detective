import 'package:hive/hive.dart';

part 'sms_model.g.dart'; // Hive will generate this file

@HiveType(typeId: 0)
class SmsModel extends HiveObject {
  @HiveField(0)
  final String? sender;

  @HiveField(1)
  final String? body;

  @HiveField(2)
  final DateTime? timestamp;

  @HiveField(3)
  bool isPhishing; // You'll update this based on your detection logic

  SmsModel({this.sender, this.body, this.timestamp, this.isPhishing = false});
}
