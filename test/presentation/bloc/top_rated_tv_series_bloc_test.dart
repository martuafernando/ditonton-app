import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late TopRatedTvSeriesBloc bloc;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() => {
        mockGetTopRatedTvSeries = MockGetTopRatedTvSeries(),
        bloc = TopRatedTvSeriesBloc(
            getTopRatedTvSeries: mockGetTopRatedTvSeries)
      });

  group('Top Rated Tv Series', () {
    test('Initial state should be TopRatedTvSeriesInitial', () {
      expect(bloc.state, TopRatedTvSeriesInitial());
    });

    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'should emits [Loading, Loaded] when fetchTopRatedTvSeries successfully.',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        TopRatedTvSeriesLoading(),
        TopRatedTvSeriesLoaded(testTvSeriesList),
      ],
      verify: (block) => verify(mockGetTopRatedTvSeries.execute()),
    );

    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'should emits [Loading, Error] when fetchTopRatedTvSeries failed.',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        TopRatedTvSeriesLoading(),
        TopRatedTvSeriesError('Server Failure'),
      ],
      verify: (block) => verify(mockGetTopRatedTvSeries.execute()),
    );
  });
}
