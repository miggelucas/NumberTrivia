import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart";
import "package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart";

import "../../../fixtures/fixture_reader.dart";

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test text");

  test('should be a subcasst of NumberTrivia', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture("trivia.json"));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = tNumberTriviaModel.toJson();

      final expectedMap = {
        "text": "test text",
        "number": 1,
      };

      expect(result, expectedMap);
    });
  });
}
