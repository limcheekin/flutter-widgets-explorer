import 'dart:convert';
import 'dart:io';

import 'package:number_trivia/domain/entities/number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  static const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

  /// Gets the cached [NumberTrivia] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [FileSystemException] if no cached data is present.
  Future<NumberTrivia> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTrivia triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTrivia> getLastNumberTrivia() {
    final jsonString = sharedPreferences
        .getString(NumberTriviaLocalDataSource.CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      // Future which is immediately completed
      return Future.value(NumberTrivia.fromJson(json.decode(jsonString)));
    } else {
      throw FileSystemException(
          'Value of ${NumberTriviaLocalDataSource.CACHED_NUMBER_TRIVIA} not found in local storage!');
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTrivia triviaToCache) {
    return sharedPreferences.setString(
      NumberTriviaLocalDataSource.CACHED_NUMBER_TRIVIA,
      json.encode(triviaToCache.toJson()),
    );
  }
}
