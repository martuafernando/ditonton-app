import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/airing_today_tv_series_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<MovieListNotifier>(context, listen: false)
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies());

    Future.microtask(
        () => Provider.of<TvSeriesListNotifier>(context, listen: false)
          ..fetchAiringTodayTvSeries()
          ..fetchPopularTvSeries()
          ..fetchTopRatedTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/circle-g.png'),
                ),
                accountName: Text('Fernando'),
                accountEmail: Text('fernandosibarani45@gmail.com'),
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                ) 
              ),
              ListTile(
                leading: Icon(Icons.home_outlined),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.save_alt),
                title: Text('Watchlist'),
                onTap: () {
                  Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
                },
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
                },
                leading: Icon(Icons.info_outline),
                title: Text('About'),
              ),
            ],
          ),
        ),
        appBar: AppBar(
            title: Text('Ditonton'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
                },
                icon: Icon(Icons.search),
              )
            ],
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
                      Text('TV Series'),
                    ],
                  ),
                ),
              ],
            )),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Now Playing',
                      style: kTitleLarge,
                    ),
                    Consumer<MovieListNotifier>(
                        builder: (context, data, child) {
                      final state = data.nowPlayingState;
                      switch (state) {
                        case RequestState.Loading:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        case RequestState.Loaded:
                          return MovieList(data.nowPlayingMovies);
                        default:
                          return Text('Failed');
                      }
                    }),
                    SizedBox(height: 24),
                    _buildSubHeading(
                      title: 'Popular',
                      onTap: () => Navigator.pushNamed(
                          context, PopularMoviesPage.ROUTE_NAME),
                    ),
                    Consumer<MovieListNotifier>(
                        builder: (context, data, child) {
                      final state = data.popularMoviesState;
                      switch (state) {
                        case RequestState.Loading:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        case RequestState.Loaded:
                          return MovieList(data.popularMovies);
                        default:
                          return Text('Failed');
                      }
                    }),
                    SizedBox(height: 24),
                    _buildSubHeading(
                      title: 'Top Rated',
                      onTap: () => Navigator.pushNamed(
                          context, TopRatedMoviesPage.ROUTE_NAME),
                    ),
                    Consumer<MovieListNotifier>(
                        builder: (context, data, child) {
                      final state = data.topRatedMoviesState;
                      switch (state) {
                        case RequestState.Loading:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        case RequestState.Loaded:
                          return MovieList(data.topRatedMovies);
                        default:
                          return Text('Failed');
                      }
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubHeading(
                      title: 'Airing Today',
                      onTap: () => Navigator.pushNamed(
                          context, AiringTodayTvSeriesPage.ROUTE_NAME),
                    ),
                    Consumer<TvSeriesListNotifier>(
                        builder: (context, data, child) {
                      final state = data.airingTodayTvSeriesState;
                      switch (state) {
                        case RequestState.Loading:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        case RequestState.Loaded:
                          return TvSeriesList(data.airingTodayTvSeries);
                        default:
                          return Text('Failed');
                      }
                    }),
                    SizedBox(height: 24),
                    _buildSubHeading(
                      title: 'Popular',
                      onTap: () => Navigator.pushNamed(
                          context, PopularTvSeriesPage.ROUTE_NAME),
                    ),
                    Consumer<TvSeriesListNotifier>(
                        builder: (context, data, child) {
                      final state = data.popularTvSeriesState;
                      switch (state) {
                        case RequestState.Loading:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        case RequestState.Loaded:
                          return TvSeriesList(data.popularTvSeries);
                        default:
                          return Text('Failed');
                      }
                    }),
                    SizedBox(height: 24),
                    _buildSubHeading(
                      title: 'Top Rated',
                      onTap: () => Navigator.pushNamed(
                          context, TopRatedTvSeriesPage.ROUTE_NAME),
                    ),
                    Consumer<TvSeriesListNotifier>(
                        builder: (context, data, child) {
                      final state = data.topRatedTvSeriesState;
                      switch (state) {
                        case RequestState.Loading:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        case RequestState.Loaded:
                          return TvSeriesList(data.topRatedTvSeries);
                        default:
                          return Text('Failed');
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kTitleLarge,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  TvSeriesList(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
