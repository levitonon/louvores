class Louvor {
  final String title;
  final String lyrics;
  final String category;

  Louvor({
    required this.title,
    required this.lyrics,
    required this.category,
  });

  factory Louvor.fromJson(Map<String, dynamic> json) {
    return Louvor(
      title: json['title'],
      lyrics: json['lyrics'],
      category: json['category'],
    );
  }
}
