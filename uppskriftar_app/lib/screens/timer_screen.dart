import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timer_provider.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '$minutes minute${minutes > 1 ? 's' : ''} ${remainingSeconds > 0 ? '$remainingSeconds second${remainingSeconds > 1 ? 's' : ''}' : ''}';
    } else {
      return '$remainingSeconds second${remainingSeconds > 1 ? 's' : ''}';
    }
  }

  void _showTimeUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Time’s Up!'),
        content: const Text('The timer has finished counting down.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    // Show "time's up" dialog if timer reaches 0
    if (timerState.remainingTime == 0 && !timerState.isRunning) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTimeUpDialog(context);
      });
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Time Remaining: ${formatTime(timerState.remainingTime)}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        Slider(
          value: timerState.remainingTime.toDouble().clamp(10.0, 3600.0),
          min: 10,
          max: 3600,
          divisions: 36,
          label: formatTime(timerState.remainingTime),
          onChanged: timerState.isRunning
              ? null
              : (value) {
            timerNotifier.updateTimer(value.toInt());
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: timerState.isRunning ? null : timerNotifier.startTimer,
          child: const Text('Start Timer'),
        ),
      ],
    );
  }
}
