import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/search_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_series_search_event.dart';
part 'tv_series_search_state.dart';

class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchBloc({required this.searchTvSeries})
      : super(TvSeriesSearchInitial()) {
    on<FetchTvSeriesSearch>((event, emit) async {
      emit(TvSeriesSearchLoading());
      final result = await searchTvSeries.execute(event.query);

      result.fold(
        (failure) {
          emit(TvSeriesSearchError(failure.message));
        },
        (movies) {
          emit(TvSeriesSearchLoaded(movies));
        },
      );
    });
  }
}
