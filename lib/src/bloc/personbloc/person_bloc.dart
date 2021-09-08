import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/src/bloc/personbloc/person_bloc_event.dart';
import 'package:tmdb/src/bloc/personbloc/person_bloc_state.dart';
import 'package:tmdb/src/model/person.dart';
import 'package:tmdb/src/service/api_service.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(PersonLoading());

  @override
  Stream<PersonState> mapEventToState(PersonEvent event) async* {
    if (event is PersonEventStarted) {
      yield* _mapMovieEventStateToState();
    }
  }

  Stream<PersonState> _mapMovieEventStateToState() async* {
    final service = ApiService();
    yield PersonLoading();
    try {
      List<Person> personList = await service.getTrendingPerson();

      yield PersonLoaded(personList);
    } on Exception catch (_) {
      yield PersonError();
    }
  }
}
