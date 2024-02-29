import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_now_playing_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'airing_today_tv_series_event.dart';
part 'airing_today_tv_series_state.dart';

class AiringTodayTvSeriesBloc
    extends Bloc<AiringTodayTvSeriesEvent, AiringTodayTvSeriesState> {
  final GetAiringTodayTvSeries getAiringTodayTvSeries;

  AiringTodayTvSeriesBloc({required this.getAiringTodayTvSeries})
      : super(AiringTodayTvSeriesInitial()) {
    on<fetchAiringTodayTvSeries>((event, emit) async {
      emit(AiringTodayTvSeriesLoading());
      final result = await getAiringTodayTvSeries.execute();

      result.fold(
        (failure) {
          emit(AiringTodayTvSeriesError(failure.message));
        },
        (tvSeriesData) {
          emit(AiringTodayTvSeriesLoaded(tvSeriesData));
        },
      );
    });
  }
}
