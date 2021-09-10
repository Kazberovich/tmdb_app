import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/src/bloc/moviedetailsbloc/movie_details_bloc_event.dart';
import 'package:tmdb/src/bloc/moviedetailsbloc/movie_details_bloc_state.dart';
import 'package:tmdb/src/model/movie_detail.dart';
import 'package:tmdb/src/service/api_service.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc() : super(MovieDetailsLoading());

  @override
  Stream<MovieDetailsState> mapEventToState(MovieDetailsEvent event) async* {
    if (event is MovieDetailsEventStarted) {
      yield* _mapMovieEventStateToState(event.id);
    }
  }

  Stream<MovieDetailsState> _mapMovieEventStateToState(int movieId) async* {
    final service = ApiService();
    yield MovieDetailsLoading();
    try {
      final MovieDetails movieDetails = await service.getMovieDetails(movieId);

      yield MovieDetailsLoaded(movieDetails);
    } on Exception catch (_) {
      yield MovieDetailsError();
    }
  }
}
