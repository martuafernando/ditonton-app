part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistTvSeriesInitial extends WatchlistTvSeriesState {}

class WatchlistTvSeriesLoading extends WatchlistTvSeriesState {}

class WatchlistTvSeriesLoaded extends WatchlistTvSeriesState {
  final List<TvSeries> tvSeries;

  WatchlistTvSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class WatchlistTvSeriesError extends WatchlistTvSeriesState {
  final String message;

  WatchlistTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvSeriesAdded extends WatchlistTvSeriesState {}

class WatchlistTvSeriesNotAdded extends WatchlistTvSeriesState {}

class WatchlistTvSeriesRemoved extends WatchlistTvSeriesState {}