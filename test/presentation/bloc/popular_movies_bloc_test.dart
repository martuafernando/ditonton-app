import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie_feature/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesBloc bloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() => {
        mockGetPopularMovies = MockGetPopularMovies(),
        bloc = PopularMoviesBloc(
            getPopularMovies: mockGetPopularMovies)
      });

  group('Popular Movies', () {
    test('Initial state should be PopularMoviesInitial', () {
      expect(bloc.state, PopularMoviesInitial());
    });

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'should emits [Loading, Loaded] when fetchPopularMovies successfully.',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        PopularMoviesLoading(),
        PopularMoviesLoaded(testMovieList),
      ],
      verify: (block) => verify(mockGetPopularMovies.execute()),
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'should emits [Loading, Error] when fetchPopularMovies failed.',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        PopularMoviesLoading(),
        PopularMoviesError('Server Failure'),
      ],
      verify: (block) => verify(mockGetPopularMovies.execute()),
    );
  });
}
