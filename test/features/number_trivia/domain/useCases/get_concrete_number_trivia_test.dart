import "package:dartz/dartz.dart";
import 'package:mocktail/mocktail.dart';
import "package:numbers_trivia/core/usecases/usecase.dart";
import "package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart";
import "package:numbers_trivia/features/number_trivia/domain/repositories/NumberTriviaRepositoryble.dart";
import 'package:flutter_test/flutter_test.dart';
import "package:numbers_trivia/features/number_trivia/domain/useCases/get_concrete_number_trivia.dart";

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepositoryble {}

void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetConcreteNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: "test");

  test('should get trivia for the number from the repository', () async {
    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any()))
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase(Params(number: tNumber));

    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));

    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
