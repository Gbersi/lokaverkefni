import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState {
  final int remainingTime;

  TimerState({required this.remainingTime});

  TimerState copyWith({int? remainingTime}) {
    return TimerState(
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(TimerState(remainingTime: 60));

  void updateTimer(int seconds) {
    if (seconds >= 10 && seconds <= 3600) {
      state = state.copyWith(remainingTime: seconds);
    }
  }

  void startTimer() {
    
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>(
      (ref) => TimerNotifier(),
);
