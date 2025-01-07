import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial());

  late int targetNumber;
  late int attemptsLeft;

  void startGame(int n, int m) {
    targetNumber = Random().nextInt(n) + 1;
    attemptsLeft = m;
    emit(GameInProgress(attemptsLeft));
  }

  void guessNumber(int guess) {
    if (guess == targetNumber) {
      emit(GameSuccess());
    } else {
      attemptsLeft--;
      if (attemptsLeft <= 0) {
        emit(GameFailure(targetNumber));
      } else {
        emit(GameInProgress(attemptsLeft));
      }
    }
  }

  void resetGame() {
    emit(GameInitial());
  }
}

abstract class GameState {}

class GameInitial extends GameState {}

class GameInProgress extends GameState {
  final int attemptsLeft;
  GameInProgress(this.attemptsLeft);
}

class GameSuccess extends GameState {}

class GameFailure extends GameState {
  final int targetNumber;
  GameFailure(this.targetNumber);
}