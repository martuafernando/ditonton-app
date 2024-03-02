import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie_feature/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_recommendations_event.dart';
part 'movie_recommendations_state.dart';

class MovieRecommendationsBloc
    extends Bloc<MovieRecommendationsEvent, MovieRecommendationsState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationsBloc({required this.getMovieRecommendations})
      : super(MovieRecommendationsInitial()) {
    on<FetchMovieRecommendations>((event, emit) async {
      emit(MovieRecommendationsLoading());
      final result = await getMovieRecommendations.execute(event.id);

      result.fold(
        (failure) {
          emit(MovieRecommendationsError(failure.message));
        },
        (movieRecommendations) {
          emit(MovieRecommendationsLoaded(movieRecommendations));
        },
      );
    });
  }
}
