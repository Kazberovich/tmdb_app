import 'package:equatable/equatable.dart';
import 'package:tmdb/src/model/movie_detail.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object?> get props => [];
}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetails details;
  const MovieDetailsLoaded(this.details);

  @override
  List<Object?> get props => [details];
}

class MovieDetailsError extends MovieDetailsState {}
