part of 'watchlist_movies_bloc.dart';

abstract class WatchlistMoviesEvent extends Equatable {
  const WatchlistMoviesEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlistMovies extends WatchlistMoviesEvent {}

class AddToWatchList extends WatchlistMoviesEvent {
  final MovieDetail moviesDetail;

  AddToWatchList(this.moviesDetail);

  @override
  List<Object> get props => [moviesDetail];
}

class RemoveFromWatchList extends WatchlistMoviesEvent {
  final MovieDetail moviesDetail;

  RemoveFromWatchList(this.moviesDetail);

  @override
  List<Object> get props => [moviesDetail];
}

class LoadWatchlistStatus extends WatchlistMoviesEvent {
  final int moviesId;

  LoadWatchlistStatus(this.moviesId);

  @override
  List<Object> get props => [moviesId];
}