import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_tv_series_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_series_recommendations_event.dart';
part 'tv_series_recommendations_state.dart';

class TvSeriesRecommendationsBloc
    extends Bloc<TvSeriesRecommendationsEvent, TvSeriesRecommendationsState> {
  final GetTvSeriesRecommendations getTvSeriesRecommendations;

  TvSeriesRecommendationsBloc({required this.getTvSeriesRecommendations})
      : super(TvSeriesRecommendationsInitial()) {
    on<FetchTvSeriesRecommendations>((event, emit) async {
      emit(TvSeriesRecommendationsLoading());
      final result = await getTvSeriesRecommendations.execute(event.id);

      result.fold(
        (failure) {
          emit(TvSeriesRecommendationsError(failure.message));
        },
        (movieRecommendations) {
          emit(TvSeriesRecommendationsLoaded(movieRecommendations));
        },
      );
    });
  }
}
