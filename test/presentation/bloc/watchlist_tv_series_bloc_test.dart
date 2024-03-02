import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvSeries,
  GetWatchListStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late WatchlistTvSeriesBloc bloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late MockGetWatchListStatusTvSeries mockGetWatchlistStatusTvSeries;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() => {
        mockGetWatchlistTvSeries = MockGetWatchlistTvSeries(),
        mockGetWatchlistStatusTvSeries = MockGetWatchListStatusTvSeries(),
        mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries(),
        mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries(),

        bloc = WatchlistTvSeriesBloc(
          getWatchlistTvSeries: mockGetWatchlistTvSeries,
          getWatchListStatusTvSeries: mockGetWatchlistStatusTvSeries,
          saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
          removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
        )
      });

  group('Watchlist Tv Series', () {
    test('Initial state should be WatchlistTvSeriesInitial', () {
      expect(bloc.state, WatchlistTvSeriesInitial());
    });

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emits [Loading, Loaded] when fetchWatchlistTvSeries successfully.',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesLoaded(testTvSeriesList),
      ],
      verify: (block) => verify(mockGetWatchlistTvSeries.execute()),
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emits [Loading, Error] when fetchWatchlistTvSeries failed.',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesError('Server Failure'),
      ],
      verify: (block) => verify(mockGetWatchlistTvSeries.execute()),
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emits [Loading, Added] when SaveWatchlistTvSeries successfully.',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        return bloc;
      },
      act: (bloc) => bloc.add(AddToWatchList(testTvSeriesDetail)),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesAdded(),
      ],
      verify: (block) => verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail)),
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emits [Loading, Error] when SaveWatchlistTvSeries failed.',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(AddToWatchList(testTvSeriesDetail)),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesError('Server Failure'),
      ],
      verify: (block) => verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail)),
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emits [Loading, Removed] when RemoveFromWatchList successfully.',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchList(testTvSeriesDetail)),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesRemoved(),
      ],
      verify: (block) => verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail)),
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emits [Loading, Error] when RemoveFromWatchList failed.',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchList(testTvSeriesDetail)),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesError('Server Failure'),
      ],
      verify: (block) => verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail)),
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emits [Loading, Added] when LoadWatchlistStatus true',
      build: () {
        when(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(testMovieDetail.id)),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesAdded(),
      ],
      verify: (block) => verify(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id)),
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emits [Loading, Added] when LoadWatchlistStatus false',
      build: () {
        when(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(testMovieDetail.id)),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesNotAdded(),
      ],
      verify: (block) => verify(mockGetWatchlistStatusTvSeries.execute(testTvSeriesDetail.id)),
    );
  });
}
