import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie_feature/get_movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detal_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() => {
        mockGetMovieDetail = MockGetMovieDetail(),
        bloc = MovieDetailBloc(
            getMovieDetail: mockGetMovieDetail)
      });

  group('Movie detail', () {
    test('Initial state should be MovieDetailInitial', () {
      expect(bloc.state, MovieDetailInitial());
    });

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emits [Loading, Loaded] when fetchMovieDetail successfully.',
      build: () {
        when(mockGetMovieDetail.execute(testMovieDetail.id))
            .thenAnswer((_) async => Right(testMovieDetail));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadDetailMovie(testMovieDetail.id)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(testMovieDetail),
      ],
      verify: (block) => verify(mockGetMovieDetail.execute(testMovieDetail.id)),
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emits [Loading, Error] when fetchMovieDetail failed.',
      build: () {
        when(mockGetMovieDetail.execute(testMovieDetail.id))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadDetailMovie(testMovieDetail.id)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailError('Server Failure'),
      ],
      verify: (block) => verify(mockGetMovieDetail.execute(testMovieDetail.id)),
    );
  });
}
