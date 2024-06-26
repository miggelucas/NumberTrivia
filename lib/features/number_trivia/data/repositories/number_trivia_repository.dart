import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/error/exception.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/network/network_infoble.dart';
import 'package:numbers_trivia/features/number_trivia/data/dataSources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/dataSources/number_trivia_remote_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepository implements NumberTriviaRepositoryble {
  final NumberTriviaRemoteDataSourceble remoteDataSource;
  final NumberTriviaLocalDataSourceble localDataSource;
  final NetworkInfoble networkInfo;

  NumberTriviaRepository(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTriva =
            await remoteDataSource.getConcreteNumberTrivia(number);
        localDataSource.cacheNumberTrivia(remoteTriva);
        return Right(remoteTriva);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await remoteDataSource.getRandomNumberTrivia();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
