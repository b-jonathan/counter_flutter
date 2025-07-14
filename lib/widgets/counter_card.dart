import 'package:flutter/material.dart';

class CounterCard extends StatelessWidget {
  final int counter;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CounterCard({
    super.key,
    required this.counter,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        border: Border.all(color: Colors.amber, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('You have pushed the button this many times:'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: onDecrement,
                tooltip: 'Decrement',
                child: const Icon(Icons.remove),
              ),
              Text(
                '$counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              FloatingActionButton(
                onPressed: onIncrement,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
