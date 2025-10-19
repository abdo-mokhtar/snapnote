import 'package:hive/hive.dart';
part 'note_model.g.dart'; // في النهاية

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String text;

  @HiveField(2)
  String title;

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime date;

  Note({
    required this.id,
    required this.text,
    required this.title,
    required this.category,
    required this.date,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        text: json['text'],
        title: json['title'],
        category: json['category'],
        date: DateTime.parse(json['date']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'title': title,
        'category': category,
        'date': date.toIso8601String(),
      };
}
