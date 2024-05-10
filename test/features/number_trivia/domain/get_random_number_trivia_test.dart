import "package:dartz/dartz.dart";
import 'package:mocktail/mocktail.dart';
import "package:numbers_trivia/core/usecases/usecase.dart";
import "package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart";
import "package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart";
import 'package:flutter_test/flutter_test.dart';
import "package:numbers_trivia/features/number_trivia/domain/useCases/get_random_number_triviar.dart";

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepositoryble {}

void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetRandomNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(number: 1, text: "test");

  test('should get trivia from the repository', () async {
    when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase(NoParams());

    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
