import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_Series/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_Series/tv_series_model.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvSeriesModel = TvSeriesModel(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    voteAverage: 7.2,
    voteCount: 13507,
    firstAirDate: '2002-04-07',
    name: 'name',
    originalName: 'originalName',
    originCountry: ['US'],
    originalLanguage: 'en',
  );

  final tTvSeries = TvSeries(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    voteAverage: 7.2,
    voteCount: 13507,
    firstAirDate: '2002-04-07',
    name: 'name',
    originalName: 'originalName',
    originCountry: ['US'],
    originalLanguage: 'en',
  );

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('Airing Today TvSeries', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getAiringTodayTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.getAiringTodayTvSeries();
      // assert
      verify(mockRemoteDataSource.getAiringTodayTvSeries());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getAiringTodayTvSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getAiringTodayTvSeries();
      // assert
      verify(mockRemoteDataSource.getAiringTodayTvSeries());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getAiringTodayTvSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getAiringTodayTvSeries();
      // assert
      verify(mockRemoteDataSource.getAiringTodayTvSeries());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular TvSeries', () {
    test('should return tvSeries list when call to data source is success',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.getPopularTvSeries();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTvSeries();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTvSeries();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated TvSeries', () {
    test('should return tvSeries list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.getTopRatedTvSeries();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTvSeries();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTvSeries();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get TvSeries Detail', () {
    final tId = 1399;
    final tTvSeriesDetailResponse = TvSeriesDetailResponse(
      backdropPath: '/6LWy0jvMpmjoS9fojNgHIKoWL05.jpg',
      episodeRunTime: [60],
      genres: [GenreModel(id: 1, name: 'Action')],
      id: 1,
      overview: 'overview',
      posterPath: 'posterPath',
      firstAirDate: '2002-05-01',
      name: 'name',
      voteAverage: 1,
      voteCount: 1,
      originalName: 'originalName',
      originalLanguage: 'originalLanguage',
      originCountry: ['US'],
      popularity: 1,
      adult: false,
      createdBy: [
        CreatedBy(
            id: 9813,
            creditId: "5256c8c219c2956ff604858a",
            name: "David Benioff",
            gender: 2,
            profilePath: "/xvNN5huL0X8yJ7h3IZfGG4O2zBD.jpg"),
        CreatedBy(
            id: 228068,
            creditId: "552e611e9251413fea000901",
            name: "D.B. Weiss",
            gender: 2,
            profilePath: "/2RMejaT793U9KRk2IEbFfteQntE.jpg")
      ],
      homepage: "http://www.hbo.com/game-of-thrones",
      inProduction: false,
      languages: ["en"],
      lastAirDate: "2019-05-19",
      lastEpisodeToAir: LastEpisodeToAir(
          id: 1551830,
          name: "The Iron Throne",
          overview:
              "In the aftermath of the devastating attack on King's Landing, Daenerys must face the survivors.",
          voteAverage: 4.809,
          voteCount: 241,
          airDate: DateTime.parse("2019-05-19"),
          episodeNumber: 6,
          productionCode: "806",
          runtime: 80,
          seasonNumber: 8,
          showId: 1399,
          stillPath: "/zBi2O5EJfgTS6Ae0HdAYLm9o2nf.jpg"),
      nextEpisodeToAir: null,
      networks: [
        Network(
            id: 49,
            logoPath: "/tuomPhY2UtuPTqqFnKMVHvSb724.png",
            name: "HBO",
            originCountry: "US")
      ],
      numberOfEpisodes: 73,
      numberOfSeasons: 8,
      productionCompanies: [
        Network(
            id: 76043,
            logoPath: "/9RO2vbQ67otPrBLXCaC8UMp3Qat.png",
            name: "Revolution Sun Studios",
            originCountry: "US"),
        Network(
            id: 12525,
            logoPath: null,
            name: "Television 360",
            originCountry: ""),
        Network(
            id: 5820,
            logoPath: null,
            name: "Generator Entertainment",
            originCountry: "GB"),
        Network(
            id: 12526,
            logoPath: null,
            name: "Bighead Littlehead",
            originCountry: "")
      ],
      productionCountries: [
        ProductionCountry(iso31661: "GB", name: "United Kingdom"),
        ProductionCountry(iso31661: "US", name: "United States of America")
      ],
      seasons: [
        Season(
            airDate: DateTime.parse("2010-12-05"),
            episodeCount: 272,
            id: 3627,
            name: "Specials",
            overview: "",
            posterPath: "/kMTcwNRfFKCZ0O2OaBZS0nZ2AIe.jpg",
            seasonNumber: 0,
            voteAverage: 0),
        Season(
            airDate: DateTime.parse("2011-04-17"),
            episodeCount: 10,
            id: 3624,
            name: "Season 1",
            overview:
                "Trouble is brewing in the Seven Kingdoms of Westeros. For the driven inhabitants of this visionary world, control of Westeros' Iron Throne holds the lure of great power. But in a land where the seasons can last a lifetime, winter is coming...and beyond the Great Wall that protects them, an ancient evil has returned. In Season One, the story centers on three primary areas: the Stark and the Lannister families, whose designs on controlling the throne threaten a tenuous peace; the dragon princess Daenerys, heir to the former dynasty, who waits just over the Narrow Sea with her malevolent brother Viserys; and the Great Wall--a massive barrier of ice where a forgotten danger is stirring.",
            posterPath: "/wgfKiqzuMrFIkU1M68DDDY8kGC1.jpg",
            seasonNumber: 1,
            voteAverage: 8.3),
        Season(
            airDate: DateTime.parse("2012-04-01"),
            episodeCount: 10,
            id: 3625,
            name: "Season 2",
            overview:
                "The cold winds of winter are rising in Westeros...war is coming...and five kings continue their savage quest for control of the all-powerful Iron Throne. With winter fast approaching, the coveted Iron Throne is occupied by the cruel Joffrey, counseled by his conniving mother Cersei and uncle Tyrion. But the Lannister hold on the Throne is under assault on many fronts. Meanwhile, a new leader is rising among the wildings outside the Great Wall, adding new perils for Jon Snow and the order of the Night's Watch.",
            posterPath: "/9xfNkPwDOqyeUvfNhs1XlWA0esP.jpg",
            seasonNumber: 2,
            voteAverage: 8.2),
        Season(
            airDate: DateTime.parse("2013-03-31"),
            episodeCount: 10,
            id: 3626,
            name: "Season 3",
            overview:
                "Duplicity and treachery...nobility and honor...conquest and triumph...and, of course, dragons. In Season 3, family and loyalty are the overarching themes as many critical storylines from the first two seasons come to a brutal head. Meanwhile, the Lannisters maintain their hold on King's Landing, though stirrings in the North threaten to alter the balance of power; Robb Stark, King of the North, faces a major calamity as he tries to build on his victories; a massive army of wildlings led by Mance Rayder march for the Wall; and Daenerys Targaryen--reunited with her dragons--attempts to raise an army in her quest for the Iron Throne.",
            posterPath: "/5MkZjRnCKiIGn3bkXrXfndEzqOU.jpg",
            seasonNumber: 3,
            voteAverage: 8.2),
      ],
      spokenLanguages: [
        SpokenLanguage(englishName: "English", iso6391: "en", name: "English")
      ],
      status: "Ended",
      tagline: "Winter Is Coming",
      type: "Scripted",
    );

    test(
        'should return TvSeries data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenAnswer((_) async => tTvSeriesDetailResponse);
      // act
      final result = await repository.getTvSeriesDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, equals(Right(testTvSeriesDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvSeriesDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvSeriesDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get TvSeries Recommendations', () {
    final tTvSeriesList = <TvSeriesModel>[];
    final tId = 1;

    test('should return data (tvSeries list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenAnswer((_) async => tTvSeriesList);
      // act
      final result = await repository.getTvSeriesRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvSeriesList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvSeriesRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach TvSeries', () {
    final tQuery = 'spiderman';

    test('should return tvSeries list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.searchTvSeries(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTvSeries(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTvSeries(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTvSeriesById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tvSeries', () {
    test('should return list of TvSeries', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesTable]);
      // act
      final result = await repository.getWatchlistTvSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvSeries]);
    });
  });
}
