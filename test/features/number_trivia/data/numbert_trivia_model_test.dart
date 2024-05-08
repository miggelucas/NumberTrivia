import "package:flutter_test/flutter_test.dart";
import "package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart";
import "package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart";

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test('should be a subcasst of NumberTrivia', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
}