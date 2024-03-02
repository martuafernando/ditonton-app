import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late WatchlistMoviesBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchlistStatusMovies;
  late MockSaveWatchlist mockSaveWatchlistMovies;
  late MockRemoveWatchlist mockRemoveWatchlistMovies;

  setUp(() => {
        mockGetWatchlistMovies = MockGetWatchlistMovies(),
        mockGetWatchlistStatusMovies = MockGetWatchListStatus(),
        mockSaveWatchlistMovies = MockSaveWatchlist(),
        mockRemoveWatchlistMovies = MockRemoveWatchlist(),
        bloc = WatchlistMoviesBloc(
          getWatchlistMovies: mockGetWatchlistMovies,
          getWatchListStatusMovies: mockGetWatchlistStatusMovies,
          saveWatchlistMovies: mockSaveWatchlistMovies,
          removeWatchlistMovies: mockRemoveWatchlistMovies,
        )
      });

  group('Watchlist Tv Series', () {
    test('Initial state should be WatchlistMoviesInitial', () {
      expect(bloc.state, WatchlistMoviesInitial());
    });

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emits [Loading, Loaded] when fetchWatchlistMovies successfully.',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistMovies()),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesLoaded(testMovieList),
      ],
      verify: (block) => verify(mockGetWatchlistMovies.execute()),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emits [Loading, Error] when fetchWatchlistMovies failed.',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistMovies()),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesError('Server Failure'),
      ],
      verify: (block) => verify(mockGetWatchlistMovies.execute()),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emits [Loading, Added] when SaveWatchlistMovies successfully.',
      build: () {
        when(mockSaveWatchlistMovies.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        return bloc;
      },
      act: (bloc) => bloc.add(AddToWatchList(testMovieDetail)),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesAdded(),
      ],
      verify: (block) =>
          verify(mockSaveWatchlistMovies.execute(testMovieDetail)),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emits [Loading, Error] when SaveWatchlistMovies failed.',
      build: () {
        when(mockSaveWatchlistMovies.execute(testMovieDetail))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(AddToWatchList(testMovieDetail)),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesError('Server Failure'),
      ],
      verify: (block) =>
          verify(mockSaveWatchlistMovies.execute(testMovieDetail)),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emits [Loading, Removed] when RemoveFromWatchList successfully.',
      build: () {
        when(mockRemoveWatchlistMovies.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchList(testMovieDetail)),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesRemoved(),
      ],
      verify: (block) =>
          verify(mockRemoveWatchlistMovies.execute(testMovieDetail)),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emits [Loading, Error] when RemoveFromWatchList failed.',
      build: () {
        when(mockRemoveWatchlistMovies.execute(testMovieDetail))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchList(testMovieDetail)),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesError('Server Failure'),
      ],
      verify: (block) =>
          verify(mockRemoveWatchlistMovies.execute(testMovieDetail)),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emits [Loading, Added] when LoadWatchlistStatus true',
      build: () {
        when(mockGetWatchlistStatusMovies.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(testMovieDetail.id)),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesAdded(),
      ],
      verify: (block) =>
          verify(mockGetWatchlistStatusMovies.execute(testMovieDetail.id)),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emits [Loading, Added] when LoadWatchlistStatus false',
      build: () {
        when(mockGetWatchlistStatusMovies.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(testMovieDetail.id)),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesNotAdded(),
      ],
      verify: (block) =>
          verify(mockGetWatchlistStatusMovies.execute(testMovieDetail.id)),
    );
  });
}
