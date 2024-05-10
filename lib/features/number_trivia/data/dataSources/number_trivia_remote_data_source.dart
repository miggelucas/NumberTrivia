import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:numbers_trivia/core/error/exception.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSourceble {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSource implements NumberTriviaRemoteDataSourceble {
  final http.Client client;

  NumberTriviaRemoteDataSource({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await client.get(
      Uri.parse('http://numbersapi.com/$number'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      final jsonMap = response.body;
      final triviaModel = NumberTriviaModel.fromJson(json.decode(jsonMap));
      return Future.value(triviaModel);
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await client.get(
      Uri.parse('http://numbersapi.com/random'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      final jsonMap = response.body;
      final triviaModel = NumberTriviaModel.fromJson(json.decode(jsonMap));
      return Future.value(triviaModel);
    }
  }
}
