import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_now_playing_tv_series.dart';
import 'package:ditonton/presentation/bloc/airing_today_tv_series/airing_today_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'airing_today_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetAiringTodayTvSeries])
void main() {
  late AiringTodayTvSeriesBloc bloc;
  late MockGetAiringTodayTvSeries mockGetAiringTodayTvSeries;

  setUp(() => {
        mockGetAiringTodayTvSeries = MockGetAiringTodayTvSeries(),
        bloc = AiringTodayTvSeriesBloc(
            getAiringTodayTvSeries: mockGetAiringTodayTvSeries)
      });

  final tTvSeries = TvSeries(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    firstAirDate: '2002-05-01',
    genreIds: [14, 28],
    id: 557,
    name: 'testing',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'testing',
    overview: 'overview',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tvSeriesList = <TvSeries>[tTvSeries];

  group('Airing today Tv Series', () {
    test('Initial state should be AiringTodayTvSeriesInitial', () {
      expect(bloc.state, AiringTodayTvSeriesInitial());
    });

    blocTest<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
      'should emits [Loading, Loaded] when fetchAiringTodayTvSeries successfully.',
      build: () {
        when(mockGetAiringTodayTvSeries.execute())
            .thenAnswer((_) async => Right(tvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchAiringTodayTvSeries()),
      expect: () => [
        AiringTodayTvSeriesLoading(),
        AiringTodayTvSeriesLoaded(tvSeriesList),
      ],
      verify: (block) => verify(mockGetAiringTodayTvSeries.execute()),
    );

    blocTest<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
      'should emits [Loading, Error] when fetchAiringTodayTvSeries failed.',
      build: () {
        when(mockGetAiringTodayTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchAiringTodayTvSeries()),
      expect: () => [
        AiringTodayTvSeriesLoading(),
        AiringTodayTvSeriesError('Server Failure'),
      ],
      verify: (block) => verify(mockGetAiringTodayTvSeries.execute()),
    );
  });
}
