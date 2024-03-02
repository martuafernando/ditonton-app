import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late PopularTvSeriesBloc bloc;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() => {
        mockGetPopularTvSeries = MockGetPopularTvSeries(),
        bloc = PopularTvSeriesBloc(
            getPopularTvSeries: mockGetPopularTvSeries)
      });

  group('Popular Tv Series', () {
    test('Initial state should be PopularTvSeriesInitial', () {
      expect(bloc.state, PopularTvSeriesInitial());
    });

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'should emits [Loading, Loaded] when fetchPopularTvSeries successfully.',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        PopularTvSeriesLoading(),
        PopularTvSeriesLoaded(testTvSeriesList),
      ],
      verify: (block) => verify(mockGetPopularTvSeries.execute()),
    );

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'should emits [Loading, Error] when fetchPopularTvSeries failed.',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        PopularTvSeriesLoading(),
        PopularTvSeriesError('Server Failure'),
      ],
      verify: (block) => verify(mockGetPopularTvSeries.execute()),
    );
  });
}
