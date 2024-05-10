import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/error/exception.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/network/network_infoble.dart';
import 'package:numbers_trivia/features/number_trivia/data/dataSources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/dataSources/number_trivia_remote_data_sourceble.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSourceble {}

class MockLocalDataSource extends Mock
    implements NumberTriviaLocalDataSourceble {}

class MockNetworkInfo extends Mock implements NetworkInfoble {}

void main() {
  late NumberTriviaRepository repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel(number: tNumber, text: 'test trivia');
  final NumberTrivia tNumberTrivia = tNumberTriviaModel;

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => Future<void>);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => Future<void>);
      });

      body();
    });
  }

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'test trivia');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async => Future<void>);
      // act
      repository.getRandomNumberTrivia();
      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('devide is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => Future<void>);
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async => Future<void>);

          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async => Future<void>);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verify(
              () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => Future<void>);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getConcreteNumberTrivia', () {
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async => Future<void>);

      // act
      await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => Future<void>);
      });

      test('should return last locally cached data when cached data is present',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(() => mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(() => mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Left(CacheFailure())));
      });
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => Future<void>);
      });
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test('should cache the data locally when the call', () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => Future<void>);

        await repository.getConcreteNumberTrivia(tNumber);

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);

          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
  });
}
