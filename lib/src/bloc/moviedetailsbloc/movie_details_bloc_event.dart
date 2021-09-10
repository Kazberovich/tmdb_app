import 'package:equatable/equatable.dart';

abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();
}

class MovieDetailsEventStarted extends MovieDetailsEvent {
  final int id;
  const MovieDetailsEventStarted(this.id);

  @override
  List<Object?> get props => [];
}
