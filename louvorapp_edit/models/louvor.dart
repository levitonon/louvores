import 'package:json_annotation/json_annotation.dart';

part 'louvor.g.dart';

@JsonSerializable()
class Louvor {
  String title;
  String lyrics;
  String category;

  Louvor({required this.title, required this.lyrics, required this.category});

  factory Louvor.fromJson(Map<String, dynamic> json) => _$LouvorFromJson(json);
  Map<String, dynamic> toJson() => _$LouvorToJson(this);
}
