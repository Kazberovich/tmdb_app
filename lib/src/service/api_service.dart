import 'package:dio/dio.dart';
import 'package:tmdb/src/model/genre.dart';
import 'package:tmdb/src/model/movie.dart';
import 'package:tmdb/src/model/movie_detail.dart';
import 'package:tmdb/src/model/person.dart';

class ApiService {
  final Dio _dio = Dio();

  final String baseUrl = "https://api.themoviedb.org/3";
  final String apiKey = "48ed176d044976544817d2b4f21f3567";

  Future<List<Movie>> getNowPlayingMovie() async {
    try {
      print('API call: getNowPlayingMovie');
      print('URL: $baseUrl/movie/now_playing?api_key=$apiKey');
      final response =
          await _dio.get("$baseUrl/movie/now_playing?api_key=$apiKey");
      var movies = response.data['results'] as List;
      List<Movie> movieList = movies.map((e) => Movie.fromJson(e)).toList();
      return movieList;
    } catch (error, stackTrace) {
      throw Exception("Exception occured: $error with sracktrace: $stackTrace");
    }
  }

  Future<List<Genre>> getGenreList() async {
    try {
      print('API call: getGenreList');
      print('URL: $baseUrl/genre/movie/list?api_key=$apiKey');

      final response =
          await _dio.get("$baseUrl/genre/movie/list?api_key=$apiKey");
      var genres = response.data['genres'] as List;
      List<Genre> genreList = genres.map((e) => Genre.fromJson(e)).toList();
      return genreList;
    } catch (error, stackTrace) {
      throw Exception("Exception occured: $error with sracktrace: $stackTrace");
    }
  }

  Future<List<Movie>> getMovieByGenre(int genreId) async {
    try {
      print('API call: getMovieByGenre');
      print(
          'URL: $baseUrl/discover/movie?with_genres=$genreId&api_key=$apiKey');
      final response = await _dio
          .get("$baseUrl/discover/movie?with_genres=$genreId&api_key=$apiKey");
      var movies = response.data['results'] as List;
      List<Movie> movieList = movies.map((e) => Movie.fromJson(e)).toList();
      return movieList;
    } catch (error, stackTrace) {
      throw Exception("Exception occured: $error with sracktrace: $stackTrace");
    }
  }

  Future<List<Person>> getTrendingPerson() async {
    try {
      print('API call: getTrendingPerson');
      print('URL: $baseUrl/movie/now_playing?api_key=$apiKey');

      final response =
          await _dio.get("$baseUrl/trending/person/week?api_key=$apiKey");
      print('Response getTrendingPerson: $response');
      var persons = response.data['results'] as List;
      List<Person> personList = persons.map((e) => Person.fromJson(e)).toList();
      return personList;
    } catch (error, stackTrace) {
      throw Exception("Exception occured: $error with sracktrace: $stackTrace");
    }
  }

  Future<MovieDetails> getMovieDetails(int movieId) async {
    try {
      print('API call: getMovieDetails');
      print('URL: $baseUrl/movie/now_playing?api_key=$apiKey');

      final response =
          await _dio.get("$baseUrl/movie/$movieId?api_key=$apiKey");
      print('Response getMovieDetails: $response');
      MovieDetails details = MovieDetails.fromJson(response.data);

      details.trailerId = await getYoutubeId(movieId);

      print(details.trailerId);
      return details;
    } catch (error, stackTrace) {
      throw Exception("Exception occured: $error with sracktrace: $stackTrace");
    }
  }

  Future<String> getYoutubeId(int movieId) async {
    try {
      print('API call: getYoutubeId');
      print('URL: $baseUrl/movie/$movieId/videos?api_key=$apiKey');
      final response =
          await _dio.get("$baseUrl/movie/$movieId/videos?api_key=$apiKey");
      print('Response getYoutubeId: $response');
      var youtubeId = response.data['results'][0]['key'];
      print(youtubeId);
      return youtubeId;
    } catch (error, stackTrace) {
      throw Exception("Exception occured: $error with sracktrace: $stackTrace");
    }
  }
}
