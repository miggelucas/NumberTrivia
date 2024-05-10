import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';


abstract class NumberTriviaRemoteDataSourceble {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

