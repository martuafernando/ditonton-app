part of 'movie_recommendations_bloc.dart';

abstract class MovieRecommendationsState extends Equatable {
  const MovieRecommendationsState();

  @override
  List<Object> get props => [];
}

class MovieRecommendationsInitial extends MovieRecommendationsState {}

class MovieRecommendationsLoading extends MovieRecommendationsState {}

class MovieRecommendationsLoaded extends MovieRecommendationsState {
  final List<Movie> movieRecommendations;

  MovieRecommendationsLoaded(this.movieRecommendations);

  @override
  List<Object> get props => [movieRecommendations];
}

class MovieRecommendationsError extends MovieRecommendationsState {
  final String message;

  MovieRecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}