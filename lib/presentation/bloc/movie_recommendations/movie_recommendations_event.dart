part of 'movie_recommendations_bloc.dart';

abstract class MovieRecommendationsEvent extends Equatable {
  final int id;

  const MovieRecommendationsEvent(this.id);

  @override
  List<Object> get props => [];
}

class FetchMovieRecommendations extends MovieRecommendationsEvent {
  FetchMovieRecommendations(id) : super(id);
}