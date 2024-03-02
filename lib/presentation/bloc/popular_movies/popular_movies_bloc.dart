import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie_feature/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc
    extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc({required this.getPopularMovies})
      : super(PopularMoviesInitial()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(PopularMoviesLoading());
      final result = await getPopularMovies.execute();

      result.fold(
        (failure) {
          emit(PopularMoviesError(failure.message));
        },
        (movies) {
          emit(PopularMoviesLoaded(movies));
        },
      );
    });
  }
}
