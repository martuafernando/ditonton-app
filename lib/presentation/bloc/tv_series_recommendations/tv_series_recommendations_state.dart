part of 'tv_series_recommendations_bloc.dart';

abstract class TvSeriesRecommendationsState extends Equatable {
  const TvSeriesRecommendationsState();

  @override
  List<Object> get props => [];
}

class TvSeriesRecommendationsInitial extends TvSeriesRecommendationsState {}

class TvSeriesRecommendationsLoading extends TvSeriesRecommendationsState {}

class TvSeriesRecommendationsLoaded extends TvSeriesRecommendationsState {
  final List<TvSeries> tvSeriesRecommendations;

  TvSeriesRecommendationsLoaded(this.tvSeriesRecommendations);

  @override
  List<Object> get props => [tvSeriesRecommendations];
}

class TvSeriesRecommendationsError extends TvSeriesRecommendationsState {
  final String message;

  TvSeriesRecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}