import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timer_provider.dart';
import '../widgets/main_drawer.dart';
import '../models/meal.dart';

class TimerScreen extends ConsumerWidget {
  final List<Meal> availableMeals;

  const TimerScreen({super.key, required this.availableMeals});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      drawer: MainDrawer(availableMeals: availableMeals),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Time Remaining: ${timerState.remainingTime} seconds',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Slider(
            value: timerState.remainingTime.toDouble().clamp(10.0, 3600.0),
            min: 10,
            max: 3600,
            divisions: 36,
            label: '${timerState.remainingTime} seconds',
            onChanged: (value) {
              timerNotifier.updateTimer(value.toInt());
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: timerNotifier.startTimer,
            child: const Text('Start Timer'),
          ),
        ],
      ),
    );
  }
}

