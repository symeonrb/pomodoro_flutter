import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/model/rythm.dart';
import 'package:pomodoro_flutter/widget/big_button.dart';

class SelectRythmPage extends StatelessWidget {
  const SelectRythmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 60),
          Text(
            'Sélectionner un rythme de travail',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Travail',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Pause',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          BigButton(
            onPressed: () => Navigator.of(context).pop<Rythm>((45, 15)),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    '45 min',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '15 min',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BigButton(
            onPressed: () => Navigator.of(context).pop<Rythm>((25, 5)),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    '25 min',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '5 min',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // The following code helps to test quickly
          if (kDebugMode)
            BigButton(
              onPressed: () => Navigator.of(context).pop<Rythm>((1, 1)),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      '1 min',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '1 min',
                      textAlign: TextAlign.center,
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
