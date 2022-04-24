import 'dart:convert';

// ===============================================================================/
// TEST MODEL ====================================================================/
// ===============================================================================/

class TestModel {
  String? subject;
  String? message;

  TestModel({
    this.subject,
    this.message,
  });

  TestModel copyWith({
    String? subject,
    String? message,
  }) =>
      TestModel(
        subject: subject ?? this.subject,
        message: message ?? this.message,
      );

  // ==================================/
  //
  // JSON
  //
  factory TestModel.fromRawJson(String str) => TestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
        subject: json["subject"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "subject": subject,
        "message": message,
      };
}
