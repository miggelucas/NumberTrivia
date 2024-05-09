import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/plataform/network_infoble.dart';
import 'package:numbers_trivia/core/plataform/number_trivia_local_data_sourceble.dart';
import 'package:numbers_trivia/core/plataform/number_trivia_remote_data_sourceble.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/NumberTriviaRepositoryble.dart';

class NumberTriviaRepository implements NumberTriviaRepositoryble {
  final NumberTriviaRemoteDataSourceble remoteDataSource;
  final NumberTriviaLocalDataSourceble localDataSource;
  final NetworkInfoble networkInfo;

  NumberTriviaRepository(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    // TODO: implement getConcreteNumberTrivia
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}