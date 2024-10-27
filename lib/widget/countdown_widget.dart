import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/cubit/session_in_progress_cubit.dart';

class CountdownWidget extends StatelessWidget {
  const CountdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<SessionInProgressCubit>().state;
    if (timer == null) return const SizedBox.shrink();
    final nextStepIn = timer.nextStepIn;
    final formattedElapsed = '${nextStepIn.inMinutes}:'
        '${(nextStepIn.inSeconds % 60).toString().padLeft(2, '0')}';

    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: nextStepIn.inSeconds /
                max(1, timer.durationOfCurrentStep.inSeconds),
            strokeWidth: 5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text(
                  formattedElapsed,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                // const SizedBox(height: 10),
                IconTheme(
                  data: IconThemeData(
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                  child: timer.isRunning
                      ? IconButton(
                          onPressed:
                              context.read<SessionInProgressCubit>().pause,
                          icon: const Icon(Icons.pause),
                        )
                      : IconButton(
                          onPressed:
                              context.read<SessionInProgressCubit>().resume,
                          icon: const Icon(Icons.play_arrow),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
