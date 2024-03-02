import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie_feature/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesBloc bloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() => {
        mockGetTopRatedMovies = MockGetTopRatedMovies(),
        bloc = TopRatedMoviesBloc(
            getTopRatedMovies: mockGetTopRatedMovies)
      });

  group('Top Rated Movies', () {
    test('Initial state should be TopRatedMoviesInitial', () {
      expect(bloc.state, TopRatedMoviesInitial());
    });

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'should emits [Loading, Loaded] when fetchTopRatedMovies successfully.',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        TopRatedMoviesLoading(),
        TopRatedMoviesLoaded(testMovieList),
      ],
      verify: (block) => verify(mockGetTopRatedMovies.execute()),
    );

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'should emits [Loading, Error] when fetchTopRatedMovies failed.',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        TopRatedMoviesLoading(),
        TopRatedMoviesError('Server Failure'),
      ],
      verify: (block) => verify(mockGetTopRatedMovies.execute()),
    );
  });
}
