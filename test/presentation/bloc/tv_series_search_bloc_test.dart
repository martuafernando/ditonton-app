import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSeriesSearchBloc bloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() => {
        mockSearchTvSeries = MockSearchTvSeries(),
        bloc = TvSeriesSearchBloc(
            searchTvSeries: mockSearchTvSeries)
      });

  group('TvSeries Search', () {
    test('Initial state should be TvSeriesSearchInitial', () {
      expect(bloc.state, TvSeriesSearchInitial());
    });

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
      'should emits [Loading, Loaded] when FetchTvSeriesSearch successfully.',
      build: () {
        when(mockSearchTvSeries.execute('testing'))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesSearch('testing')),
      expect: () => [
        TvSeriesSearchLoading(),
        TvSeriesSearchLoaded(testTvSeriesList),
      ],
      verify: (block) =>
          verify(mockSearchTvSeries.execute('testing')),
    );

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
      'should emits [Loading, Error] when FetchTvSeriesSearch failed.',
      build: () {
        when(mockSearchTvSeries.execute('testing'))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesSearch('testing')),
      expect: () => [
        TvSeriesSearchLoading(),
        TvSeriesSearchError('Server Failure'),
      ],
      verify: (block) =>
          verify(mockSearchTvSeries.execute('testing')),
    );
  });
}
