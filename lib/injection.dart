import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/movie_feature/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie_feature/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie_feature/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movie_feature/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movie_feature/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/search_tv_series.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/save_watchlist.dart';
import 'package:ditonton/domain/usecases/movie_feature/search_movies.dart';
import 'package:ditonton/domain/usecases/watchlist_feature/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/airing_today_tv_series/airing_today_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_recommendations/tv_series_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init({
  required http.Client client,
}) {
  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton<http.Client>(() => client);
  
  // provider
  locator.registerFactory(
      () => NowPlayingMoviesBloc(getNowPlayingMovies: locator()));
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchBloc(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesBloc(
      getPopularMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesBloc(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMoviesBloc(
      getWatchlistMovies: locator(),
      saveWatchlistMovies: locator(),
      removeWatchlistMovies: locator(),
      getWatchListStatusMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieRecommendationsBloc(
      getMovieRecommendations: locator(),
    ),
  );

  locator.registerFactory(() => AiringTodayTvSeriesBloc(
        getAiringTodayTvSeries: locator(),
      ));
  locator.registerFactory(
    () => TvSeriesDetailBloc(
      getTvSeriesDetail: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvSeriesBloc(
      getWatchListStatusTvSeries: locator(),
      saveWatchlistTvSeries: locator(),
      getWatchlistTvSeries: locator(),
      removeWatchlistTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesRecommendationsBloc(
      getTvSeriesRecommendations: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvSeriesBloc(
      getPopularTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvSeriesBloc(
      getTopRatedTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesSearchBloc(
      searchTvSeries: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));

  locator.registerLazySingleton(() => GetAiringTodayTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTvSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));
}
