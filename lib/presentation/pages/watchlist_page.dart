import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistMoviesBloc>().add(LoadWatchlistMovies()));
    Future.microtask(
        () => context.read<WatchlistTvSeriesBloc>().add(LoadWatchlistTvSeries()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Future.microtask(
        () => context.read<WatchlistMoviesBloc>().add(LoadWatchlistMovies()));
    Future.microtask(
        () => context.read<WatchlistTvSeriesBloc>().add(LoadWatchlistTvSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie),
                    SizedBox(width: 16),
                    Text('Movies'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tv),
                    SizedBox(width: 16),
                    Text('TV'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocBuilder<WatchlistMoviesBloc, WatchlistMoviesState>(
                builder: (context, state) {
                  if (state is WatchlistMoviesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is WatchlistMoviesLoaded) {
                    return state.movies.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              final movie = state.movies[index];
                              return MovieCard(movie);
                            },
                            itemCount: state.movies.length,
                          )
                        : Center(
                            key: Key('empty_message'),
                            child: Text('No watchlist movies'),
                          );
                  }
                  return Center(
                    key: Key('error_message'),
                    child: Text(state is WatchlistMoviesError
                        ? state.message
                        : 'Unknown error'),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
                builder: (context, state) {
                  if (state is WatchlistTvSeriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is WatchlistTvSeriesLoaded) {
                    return state.tvSeries.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              final tvSeries = state.tvSeries[index];
                              return TvSeriesCard(tvSeries);
                            },
                            itemCount: state.tvSeries.length,
                          )
                        : Center(
                            key: Key('empty_message'),
                            child: Text('No watchlist tv series'),
                          );
                  }
                  return Center(
                    key: Key('error_message'),
                    child: Text(state is WatchlistTvSeriesError
                        ? state.message
                        : 'Unknown error'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
