import 'package:dio/dio.dart';
import 'package:tmdb/src/model/movie.dart';

class ApiService {
  final Dio _dio = Dio();

  final String baseUrl = "https://api.themoviedb.org/3";
  final String apiKey = "48ed176d044976544817d2b4f21f3567";

  Future<List<Movie>> getNowPlayingMovie() async {
    try {
      print('API call: getNowPlayingMovie');
      print('URL: $baseUrl/movie/now_playing?api_key=$apiKey');
      final response = await _dio.get("$baseUrl/movie/now_playing?api_key=$apiKey");
      var movies = response.data['results'] as List;
      List<Movie> movieList = movies.map((e) => Movie.fromJson(e)).toList();
      return movieList;
    } catch (error, stackTrace) {
      throw Exception("Exception occured: $error with sracktrace: $stackTrace");
    }
  }
}
