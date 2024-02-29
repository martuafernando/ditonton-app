part of 'airing_today_tv_series_bloc.dart';

abstract class AiringTodayTvSeriesState extends Equatable {
  const AiringTodayTvSeriesState();

  @override
  List<Object> get props => [];
}

class AiringTodayTvSeriesInitial extends AiringTodayTvSeriesState {}

class AiringTodayTvSeriesLoading extends AiringTodayTvSeriesState {}

class AiringTodayTvSeriesLoaded extends AiringTodayTvSeriesState {
  final List<TvSeries> tvSeries;

  AiringTodayTvSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class AiringTodayTvSeriesError extends AiringTodayTvSeriesState {
  final String message;

  AiringTodayTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}