import 'package:equatable/equatable.dart';
import 'package:tmdb/src/model/screenshot.dart';

class MovieImage extends Equatable {
  final List<Screenshot>? backdrops;
  final List<Screenshot>? posters;

  MovieImage({this.backdrops, this.posters});

  factory MovieImage.fromJson(Map<String, dynamic> result) {
    if (result == null) {
      return MovieImage();
    } else {
      return MovieImage(
          backdrops: (result['backdrops'] as List)
              .map(
                (e) => Screenshot.fromJson(e),
              )
              .toList(),
          posters: (result['posters'] as List)
              .map((e) => Screenshot.fromJson(e))
              .toList());
    }
  }

  @override
  List<Object?> get props => [backdrops, posters];
}
