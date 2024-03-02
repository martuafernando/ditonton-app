import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie_feature/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MovieRecommendationsBloc bloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() => {
        mockGetMovieRecommendations = MockGetMovieRecommendations(),
        bloc = MovieRecommendationsBloc(
            getMovieRecommendations: mockGetMovieRecommendations)
      });

  group('Movie Recommendations', () {
    test('Initial state should be MovieRecommendationsInitial', () {
      expect(bloc.state, MovieRecommendationsInitial());
    });

    blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'should emits [Loading, Loaded] when FetchMovieRecommendations successfully.',
      build: () {
        when(mockGetMovieRecommendations.execute(testMovie.id))
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieRecommendations(testMovie.id)),
      expect: () => [
        MovieRecommendationsLoading(),
        MovieRecommendationsLoaded(testMovieList),
      ],
      verify: (block) =>
          verify(mockGetMovieRecommendations.execute(testMovie.id)),
    );

    blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'should emits [Loading, Error] when FetchMovieRecommendations failed.',
      build: () {
        when(mockGetMovieRecommendations.execute(testMovie.id))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieRecommendations(testMovie.id)),
      expect: () => [
        MovieRecommendationsLoading(),
        MovieRecommendationsError('Server Failure'),
      ],
      verify: (block) =>
          verify(mockGetMovieRecommendations.execute(testMovie.id)),
    );
  });
}
