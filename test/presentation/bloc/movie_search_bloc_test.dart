import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie_feature/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc bloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() => {
        mockSearchMovies = MockSearchMovies(),
        bloc = MovieSearchBloc(
            searchMovies: mockSearchMovies)
      });

  group('Movie Search', () {
    test('Initial state should be MovieSearchInitial', () {
      expect(bloc.state, MovieSearchInitial());
    });

    blocTest<MovieSearchBloc, MovieSearchState>(
      'should emits [Loading, Loaded] when FetchMovieSearch successfully.',
      build: () {
        when(mockSearchMovies.execute('testing'))
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieSearch('testing')),
      expect: () => [
        MovieSearchLoading(),
        MovieSearchLoaded(testMovieList),
      ],
      verify: (block) =>
          verify(mockSearchMovies.execute('testing')),
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'should emits [Loading, Error] when FetchMovieSearch failed.',
      build: () {
        when(mockSearchMovies.execute('testing'))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieSearch('testing')),
      expect: () => [
        MovieSearchLoading(),
        MovieSearchError('Server Failure'),
      ],
      verify: (block) =>
          verify(mockSearchMovies.execute('testing')),
    );
  });
}
