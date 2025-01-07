import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState {
  final int remainingTime;
  final bool isRunning;

  TimerState({required this.remainingTime, required this.isRunning});

  TimerState copyWith({int? remainingTime, bool? isRunning}) {
    return TimerState(
      remainingTime: remainingTime ?? this.remainingTime,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;

  TimerNotifier() : super(TimerState(remainingTime: 60, isRunning: false));

  void updateTimer(int seconds) {
    if (seconds >= 10 && seconds <= 3600) {
      state = state.copyWith(remainingTime: seconds);
    }
  }

  void startTimer() {
    if (state.isRunning) return; // Prevent starting multiple timers

    state = state.copyWith(isRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime <= 1) {
        timer.cancel();
        state = state.copyWith(remainingTime: 0, isRunning: false);
      } else {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isRunning: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>(
      (ref) => TimerNotifier(),
);
