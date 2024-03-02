import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;
  final GetWatchListStatusTvSeries getWatchListStatusTvSeries;

  WatchlistTvSeriesBloc({
    required this.getWatchlistTvSeries,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
    required this.getWatchListStatusTvSeries,
  }) : super(WatchlistTvSeriesInitial()) {
    on<AddToWatchList>(_onAddToWatchList);
    on<RemoveFromWatchList>(_onRemoveFromWatchList);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
    on<LoadWatchlistTvSeries>(_onLoadWatchlistTvSeries);
  }

  Future<void> _onAddToWatchList(
    AddToWatchList event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    emit(WatchlistTvSeriesLoading());
    final result = await saveWatchlistTvSeries.execute(event.tvSeriesDetail);

    result.fold(
      (failure) {
        emit(WatchlistTvSeriesError(failure.message));
      },
      (movies) {
        emit(WatchlistTvSeriesAdded());
      },
    );
  }

  Future<void> _onRemoveFromWatchList(
    RemoveFromWatchList event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    emit(WatchlistTvSeriesLoading());
    final result = await removeWatchlistTvSeries.execute(event.tvSeriesDetail);

    result.fold(
      (failure) {
        emit(WatchlistTvSeriesError(failure.message));
      },
      (successMessage) {
        emit(WatchlistTvSeriesRemoved());
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    final bool isTvSeriesAdded = await getWatchListStatusTvSeries.execute(event.tvSeriesId);
    
    isTvSeriesAdded
        ? emit(WatchlistTvSeriesAdded())
        : emit(WatchlistTvSeriesNotAdded());
  }

  Future<void> _onLoadWatchlistTvSeries(
    LoadWatchlistTvSeries event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    final result = await getWatchlistTvSeries.execute();

    result.fold(
      (failure) {
        emit(WatchlistTvSeriesError(failure.message));
      },
      (movies) {
        emit(WatchlistTvSeriesLoaded(movies));
      },
    );
  }
}
