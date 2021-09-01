import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/src/model/genre.dart';
import 'package:tmdb/src/service/api_service.dart';

import 'genre_bloc_event.dart';
import 'genre_bloc_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc() : super(GenreLoading());

  @override
  Stream<GenreState> mapEventToState(GenreEvent event) async* {
    if (event is GenreEventStarted) {
      yield* _mapMovieEventStateToState();
    }
  }

  Stream<GenreState> _mapMovieEventStateToState() async* {
    final service = ApiService();
    yield GenreLoading();
    try {
      List<Genre> genreList = await service.getGenreList();

      yield GenreLoaded(genreList);
    } on Exception catch (_) {
      yield GenreError();
    }
  }
}
