part of 'tv_series_search_bloc.dart';

abstract class TvSeriesSearchState extends Equatable {
  const TvSeriesSearchState();

  @override
  List<Object> get props => [];
}

class TvSeriesSearchInitial extends TvSeriesSearchState {}

class TvSeriesSearchLoading extends TvSeriesSearchState {}

class TvSeriesSearchLoaded extends TvSeriesSearchState {
  final List<TvSeries> tvSeries;

  TvSeriesSearchLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class TvSeriesSearchError extends TvSeriesSearchState {
  final String message;

  TvSeriesSearchError(this.message);

  @override
  List<Object> get props => [message];
}