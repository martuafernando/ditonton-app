import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series_feature/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late TopRatedTvSeriesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    notifier =
        TopRatedTvSeriesNotifier(getTopRatedTvSeries: mockGetTopRatedTvSeries)
          ..addListener(() {
            listenerCallCount++;
          });
  });

  final tTvSeries = TvSeries(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    firstAirDate: '2002-05-01',
    genreIds: [14, 28],
    id: 557,
    name: 'testing',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'testing',
    overview: 'overview',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTvSeriesList = <TvSeries>[tTvSeries];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetTopRatedTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeriesList));
    // act
    notifier.fetchTopRatedTvSeries();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tvSeries data when data is gotten successfully',
      () async {
    // arrange
    when(mockGetTopRatedTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeriesList));
    // act
    await notifier.fetchTopRatedTvSeries();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvSeries, tTvSeriesList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTopRatedTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTopRatedTvSeries();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
