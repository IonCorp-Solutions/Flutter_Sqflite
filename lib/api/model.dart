class Anime {
  int mal_id;
  String title;
  String image;
  int year;
  Anime({required this.mal_id, required this.title, required this.image ,required this.year});

  factory Anime.fromJson(Map<String, dynamic> json) {
    int parsedYear;
    try {
      parsedYear = int.parse(json['year'].toString());
    } catch (e) {
      parsedYear = 0; // Provide a default value in case of parsing error
    }

    return Anime(
      mal_id: json['mal_id'],
      title: json['title'],
      year: parsedYear,
      image: json['images']['jpg']['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mal_id': mal_id,
      'title': title,
      'image': image,
      'year': year,
    };
  }

  factory Anime.fromMap(Map<String, dynamic> map) {
    return Anime(
      mal_id: map['mal_id'],
      title: map['title'],
      image: map['image'],
      year: map['year'],
    );
  }

}
