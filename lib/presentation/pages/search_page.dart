import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                onSubmitted: (query) {
                  context.read<MovieSearchBloc>().add(FetchMovieSearch(query));
                  context
                      .read<TvSeriesSearchBloc>()
                      .add(FetchTvSeriesSearch(query));
                },
                decoration: InputDecoration(
                  hintText: 'Search title',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.search,
              ),
            ),
            TabBar(
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
                      Text('TV Series'),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
                      builder: (context, state) {
                        if (state is MovieSearchLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is MovieSearchLoaded) {
                          final result = state.movies;
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final movie = result[index];
                              return MovieCard(movie);
                            },
                            itemCount: result.length,
                          );
                        }
                        return Center(
                          child: Text(
                            'No data',
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocBuilder<TvSeriesSearchBloc, TvSeriesSearchState>(
                      builder: (context, state) {
                        if (state is TvSeriesSearchLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is TvSeriesSearchLoaded) {
                          final result = state.tvSeries;
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final tvSeries = result[index];
                              return TvSeriesCard(tvSeries);
                            },
                            itemCount: result.length,
                          );
                        }
                        return Center(
                          child: Text(
                            'No data',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
