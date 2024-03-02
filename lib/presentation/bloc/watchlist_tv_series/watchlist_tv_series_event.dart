part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesEvent extends Equatable {
  const WatchlistTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlistTvSeries extends WatchlistTvSeriesEvent {}

class AddToWatchList extends WatchlistTvSeriesEvent {
  final TvSeriesDetail tvSeriesDetail;

  AddToWatchList(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class RemoveFromWatchList extends WatchlistTvSeriesEvent {
  final TvSeriesDetail tvSeriesDetail;

  RemoveFromWatchList(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class LoadWatchlistStatus extends WatchlistTvSeriesEvent {
  final int tvSeriesId;

  LoadWatchlistStatus(this.tvSeriesId);

  @override
  List<Object> get props => [tvSeriesId];
}