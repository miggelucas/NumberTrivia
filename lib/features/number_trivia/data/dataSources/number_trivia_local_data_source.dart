import 'dart:convert';

import 'package:numbers_trivia/core/error/exception.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSourceble {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

// ignore: constant_identifier_names
const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSource implements NumberTriviaLocalDataSourceble {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSource({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    final triviaString = json.encode(triviaToCache.toJson());

    sharedPreferences.setString(CACHED_NUMBER_TRIVIA, triviaString);

    return Future<void>.value();
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (jsonString != null) {
      final cachedTrivia = NumberTriviaModel.fromJson(jsonDecode(jsonString));
      return Future.value(cachedTrivia);
    } else {
      throw CacheException();
    }
  }
}
