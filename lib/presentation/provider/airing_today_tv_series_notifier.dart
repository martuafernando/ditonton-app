import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_now_playing_tv_series.dart';
import 'package:flutter/foundation.dart';

class AiringTodayTvSeriesNotifier extends ChangeNotifier {
  final GetAiringTodayTvSeries getAiringTodayTvSeries;

  AiringTodayTvSeriesNotifier({required this.getAiringTodayTvSeries});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvSeries> _tvSeries = [];
  List<TvSeries> get tvSeries => _tvSeries;

  String _message = '';
  String get message => _message;

  Future<void> fetchAiringTodayTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getAiringTodayTvSeries.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvSeriesData) {
        _tvSeries = tvSeriesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
