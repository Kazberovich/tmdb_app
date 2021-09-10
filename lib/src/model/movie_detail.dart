class MovieDetails {
  final String? id;
  final String? title;
  final String? backdropPath;
  final String? budget;
  final String? homePage;
  final String? originalTitle;
  final String? overview;
  final String? releaseDate;
  final String? runtime;
  final String? voteAverage;
  final String? voteCount;

  String? trailerId;

  MovieDetails({
    this.id,
    this.title,
    this.backdropPath,
    this.budget,
    this.homePage,
    this.originalTitle,
    this.overview,
    this.releaseDate,
    this.runtime,
    this.voteAverage,
    this.voteCount,
  });

  factory MovieDetails.fromJson(dynamic json) {
    if (json == null) {
      return MovieDetails();
    } else {
      return MovieDetails(
          id: json['id'].toString(),
          title: json['title'],
          backdropPath: json['backdrop_path'],
          budget: json['budget'].toString(),
          homePage: json['home_page'],
          originalTitle: json['original_title'],
          overview: json['overview'],
          releaseDate: json['release_date'],
          runtime: json['runtime'].toString(),
          voteAverage: json['vote_average'].toString(),
          voteCount: json['vote_count'].toString());
    }
  }
}
