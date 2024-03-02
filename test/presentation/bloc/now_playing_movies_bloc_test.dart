import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie_feature/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late NowPlayingMoviesBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() => {
        mockGetNowPlayingMovies = MockGetNowPlayingMovies(),
        bloc = NowPlayingMoviesBloc(
            getNowPlayingMovies: mockGetNowPlayingMovies)
      });

  group('Now Playing Movies', () {
    test('Initial state should be NowPlayingMoviesInitial', () {
      expect(bloc.state, NowPlayingMoviesInitial());
    });

    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'should emits [Loading, Loaded] when fetchNowPlayingMovies successfully.',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        NowPlayingMoviesLoading(),
        NowPlayingMoviesLoaded(testMovieList),
      ],
      verify: (block) => verify(mockGetNowPlayingMovies.execute()),
    );

    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'should emits [Loading, Error] when fetchNowPlayingMovies failed.',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        NowPlayingMoviesLoading(),
        NowPlayingMoviesError('Server Failure'),
      ],
      verify: (block) => verify(mockGetNowPlayingMovies.execute()),
    );
  });
}
