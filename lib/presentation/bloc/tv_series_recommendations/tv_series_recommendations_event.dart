part of 'tv_series_recommendations_bloc.dart';

abstract class TvSeriesRecommendationsEvent extends Equatable {
  final int id;

  const TvSeriesRecommendationsEvent(this.id);

  @override
  List<Object> get props => [];
}

class FetchTvSeriesRecommendations extends TvSeriesRecommendationsEvent {
  FetchTvSeriesRecommendations(id) : super(id);
}