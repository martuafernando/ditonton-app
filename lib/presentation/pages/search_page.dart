import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  Provider.of<MovieSearchNotifier>(context, listen: false)
                      .fetchMovieSearch(query);
                  Provider.of<TvSeriesSearchNotifier>(context, listen: false)
                      .fetchTvSeriesSearch(query);
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
                    child: Consumer<MovieSearchNotifier>(
                      builder: (context, data, child) {
                        if (data.state == RequestState.Loading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (data.state == RequestState.Loaded &&
                            data.searchResult.isNotEmpty) {
                          final result = data.searchResult;
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final movie = data.searchResult[index];
                              return MovieCard(movie);
                            },
                            itemCount: result.length,
                          );
                        } else {
                          return Center(
                            child: Text(
                              'No data',
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Consumer<TvSeriesSearchNotifier>(
                      builder: (context, data, child) {
                        if (data.state == RequestState.Loading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (data.state == RequestState.Loaded &&
                            data.searchResult.isNotEmpty) {
                          final result = data.searchResult;
                          return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final tvSeries = data.searchResult[index];
                              return TvSeriesCard(tvSeries);
                            },
                            itemCount: result.length,
                          );
                        } else {
                          return Container(
                            child: Center(
                              child: Text(
                                'No data',
                              ),
                            ),
                          );
                        }
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
