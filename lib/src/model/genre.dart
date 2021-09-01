class Genre {
  final int id;
  final String name;

  String? error;

  Genre(this.id, this.name);

  factory Genre.fromJson(dynamic json) {
    if (json == null) {
      return Genre(0, "no name");
    }
    return Genre(
      json['id'],
      json['name'],
    );
  }
}
