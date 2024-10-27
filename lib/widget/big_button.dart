import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  const BigButton({required this.onPressed, required this.child, super.key});

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Theme.of(context).colorScheme.primary,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: IconTheme(
          data: IconThemeData(
            color: Theme.of(context).colorScheme.onPrimary,
            size: 42,
          ),
          child: DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
