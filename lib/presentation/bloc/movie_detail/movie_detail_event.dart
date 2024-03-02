part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadDetailMovie extends MovieDetailEvent {
  final int id;

  LoadDetailMovie(this.id);

  @override
  List<Object> get props => [id];
}