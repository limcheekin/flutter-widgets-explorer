import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:logging/logging.dart';

class NumberTriviaPresenter extends Presenter {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  Function? getNumberTriviaOnNext;
  Function? getNumberTriviaOnComplete;
  Function? getNumberTriviaOnError;

  NumberTriviaPresenter({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
  });

  void getTriviaForConcreteNumber(String input) {
    getConcreteNumberTrivia.execute(
        _GetNumberTriviaObserver(this), Params(number: input));
  }

  void getTriviaForRandomNumber() {
    getRandomNumberTrivia.execute(_GetNumberTriviaObserver(this));
  }

  @override
  void dispose() {
    getConcreteNumberTrivia.dispose();
    getRandomNumberTrivia.dispose();
  }
}

class _GetNumberTriviaObserver extends Observer<NumberTrivia> {
  final logger = Logger('_GetNumberTriviaObserver');
  final NumberTriviaPresenter presenter;

  _GetNumberTriviaObserver(this.presenter);
  @override
  void onComplete() {
    logger.finest('onComplete()');
    if (presenter.getNumberTriviaOnComplete != null) {
      presenter.getNumberTriviaOnComplete!();
    }
  }

  @override
  void onError(e) {
    logger.finest('onError($e)');
    if (presenter.getNumberTriviaOnError != null) {
      presenter.getNumberTriviaOnError!(e);
    }
  }

  @override
  void onNext(response) {
    logger.finest('onNext($response)');
    if (presenter.getNumberTriviaOnNext != null) {
      presenter.getNumberTriviaOnNext!(response);
    }
  }
}
