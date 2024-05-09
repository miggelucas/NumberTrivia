import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia/core/plataform/network_infoble.dart';
import 'package:numbers_trivia/core/plataform/number_trivia_local_data_sourceble.dart';
import 'package:numbers_trivia/core/plataform/number_trivia_remote_data_sourceble.dart';
import 'package:numbers_trivia/features/number_trivia/data/repositories/number_trivia_repository.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSourceble {}

class MockLocalDataSource extends Mock
    implements NumberTriviaLocalDataSourceble {}

class MockNetworkInfo extends Mock implements NetworkInfoble {}

void main() {
  NumberTriviaRepository repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

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
}
