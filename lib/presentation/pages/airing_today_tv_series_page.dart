import 'package:ditonton/presentation/bloc/airing_today_tv_series/airing_today_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiringTodayTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/airing-today-tv-series';

  @override
  _AiringTodayTvSeriesPageState createState() =>
      _AiringTodayTvSeriesPageState();
}

class _AiringTodayTvSeriesPageState extends State<AiringTodayTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<AiringTodayTvSeriesBloc>()
        .add(FetchAiringTodayTvSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airing Today TvSeries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
          builder: (context, state) {
            if (state is AiringTodayTvSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is AiringTodayTvSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.tvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: state.tvSeries.length,
              );
            }
            if (state is AiringTodayTvSeriesError) {
              return Center(
                child: Text(state.message),
              );
            }
            return Center(
              child: Text('No Data'),
            );
          },
        ),
      ),
    );
  }
}
