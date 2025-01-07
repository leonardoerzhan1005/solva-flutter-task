import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Игра Угадай Число',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, // Убираем баннер отладки
      home: BlocProvider(
        create: (_) => GameCubit(),
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TextEditingController nController = TextEditingController();
  final TextEditingController mController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Игра Угадай Число'),
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          if (state is GameInitial) {
            return buildInitialInput(context);
          } else if (state is GameInProgress) {
            return buildGameInProgress(context, state.attemptsLeft);
          } else if (state is GameSuccess) {
            return buildSuccessScreen(context);
          } else if (state is GameFailure) {
            return buildFailureScreen(context, state.targetNumber);
          }
          return Container();
        },
      ),
    );
  }

  Widget buildInitialInput(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: nController,
            decoration: InputDecoration(
              labelText: 'Введите диапазон (n)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          TextField(
            controller: mController,
            decoration: InputDecoration(
              labelText: 'Введите количество попыток (m)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final n = int.tryParse(nController.text);
              final m = int.tryParse(mController.text);
              if (n != null && m != null) {
                context.read<GameCubit>().startGame(n, m);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Пожалуйста, введите правильные числа')),
                );
              }
            },
            child: Text('Начать Игру'),
          ),
        ],
      ),
    );
  }

  Widget buildGameInProgress(BuildContext context, int attemptsLeft) {
    final TextEditingController guessController = TextEditingController();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Осталось попыток: $attemptsLeft'),
          TextField(
            controller: guessController,
            decoration: InputDecoration(
              labelText: 'Введите вашу догадку',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final guess = int.tryParse(guessController.text);
              if (guess != null) {
                context.read<GameCubit>().guessNumber(guess);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Пожалуйста, введите правильное число')),
                );
              }
            },
            child: Text('Отправить Догадку'),
          ),
        ],
      ),
    );
  }

  Widget buildSuccessScreen(BuildContext context) {
    return Container(
      color: Colors.green[100],
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Поздравляем! Вы угадали число!',
                style: TextStyle(fontSize: 24, color: Colors.green),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<GameCubit>().resetGame();
                },
                child: Text('Начать Новую Игру'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFailureScreen(BuildContext context, int targetNumber) {
    return Container(
      color: Colors.red[100],
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Игра Окончена! Загаданное число было $targetNumber.',
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<GameCubit>().resetGame();
                },
                child: Text('Начать Новую Игру'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}