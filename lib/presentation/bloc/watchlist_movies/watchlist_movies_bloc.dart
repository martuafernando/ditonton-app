import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;
  final SaveWatchlist saveWatchlistMovies;
  final RemoveWatchlist removeWatchlistMovies;
  final GetWatchListStatus getWatchListStatusMovies;

  WatchlistMoviesBloc({
    required this.getWatchlistMovies,
    required this.saveWatchlistMovies,
    required this.removeWatchlistMovies,
    required this.getWatchListStatusMovies,
  }) : super(WatchlistMoviesInitial()) {
    on<AddToWatchList>(_onAddToWatchList);
    on<RemoveFromWatchList>(_onRemoveFromWatchList);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
    on<LoadWatchlistMovies>(_onLoadWatchlistMovies);
  }

  Future<void> _onAddToWatchList(
    AddToWatchList event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    emit(WatchlistMoviesLoading());
    final result = await saveWatchlistMovies.execute(event.moviesDetail);

    result.fold(
      (failure) {
        emit(WatchlistMoviesError(failure.message));
      },
      (movies) {
        emit(WatchlistMoviesAdded());
      },
    );
  }

  Future<void> _onRemoveFromWatchList(
    RemoveFromWatchList event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    emit(WatchlistMoviesLoading());
    final result = await removeWatchlistMovies.execute(event.moviesDetail);

    result.fold(
      (failure) {
        emit(WatchlistMoviesError(failure.message));
      },
      (successMessage) {
        emit(WatchlistMoviesRemoved());
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    final bool isMoviesAdded = await getWatchListStatusMovies.execute(event.moviesId);
    
    isMoviesAdded
        ? emit(WatchlistMoviesAdded())
        : emit(WatchlistMoviesNotAdded());
  }

  Future<void> _onLoadWatchlistMovies(
    LoadWatchlistMovies event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    final result = await getWatchlistMovies.execute();

    result.fold(
      (failure) {
        emit(WatchlistMoviesError(failure.message));
      },
      (movies) {
        emit(WatchlistMoviesLoaded(movies));
      },
    );
  }
}
