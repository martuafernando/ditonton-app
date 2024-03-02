import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_tv_series_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;

  TvSeriesDetailBloc({required this.getTvSeriesDetail})
      : super(TvSeriesDetailInitial()) {
    on<FetchTvSeriesDetail>((event, emit) async {
      emit(TvSeriesDetailLoading());
      final result = await getTvSeriesDetail.execute(event.id);

      result.fold(
        (failure) {
          emit(TvSeriesDetailError(failure.message));
        },
        (movieDetail) {
          emit(TvSeriesDetailLoaded(movieDetail));
        },
      );
    });
  }
}
