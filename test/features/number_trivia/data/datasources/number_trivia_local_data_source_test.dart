import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia/core/error/exception.dart';
import 'package:numbers_trivia/features/number_trivia/data/dataSources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSource dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() => {
        mockSharedPreferences = MockSharedPreferences(),
        dataSource = NumberTriviaLocalDataSource(
            sharedPreferences: mockSharedPreferences)
      });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(() => mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value',
        () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      final result = dataSource.getLastNumberTrivia;

      expect(() => result(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const triviaToCache = NumberTriviaModel(number: 1, text: 'test trivia');

    test('should call SharedPreferences to cache the data', () async {
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      dataSource.cacheNumberTrivia(triviaToCache);

      final expectedJsonString = json.encode(triviaToCache.toJson());
      verify(() => mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
