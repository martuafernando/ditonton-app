import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_tv_series_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv_series_recommendations/tv_series_recommendations_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesRecommendations])
void main() {
  late TvSeriesRecommendationsBloc bloc;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;

  setUp(() => {
        mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations(),
        bloc = TvSeriesRecommendationsBloc(
            getTvSeriesRecommendations: mockGetTvSeriesRecommendations)
      });

  group('Tv Series Recommendations', () {
    test('Initial state should be TvSeriesRecommendationsInitial', () {
      expect(bloc.state, TvSeriesRecommendationsInitial());
    });

    blocTest<TvSeriesRecommendationsBloc, TvSeriesRecommendationsState>(
      'should emits [Loading, Loaded] when FetchTvSeriesRecommendations successfully.',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(testTvSeries.id))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesRecommendations(testTvSeries.id)),
      expect: () => [
        TvSeriesRecommendationsLoading(),
        TvSeriesRecommendationsLoaded(testTvSeriesList),
      ],
      verify: (block) =>
          verify(mockGetTvSeriesRecommendations.execute(testTvSeries.id)),
    );

    blocTest<TvSeriesRecommendationsBloc, TvSeriesRecommendationsState>(
      'should emits [Loading, Error] when FetchTvSeriesRecommendations failed.',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(testTvSeries.id))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesRecommendations(testTvSeries.id)),
      expect: () => [
        TvSeriesRecommendationsLoading(),
        TvSeriesRecommendationsError('Server Failure'),
      ],
      verify: (block) =>
          verify(mockGetTvSeriesRecommendations.execute(testTvSeries.id)),
    );
  });
}
