import 'package:counter_flutter/models/counter.dart';
import 'package:flutter/material.dart';

class CounterCard extends StatelessWidget {
  final Counter counter;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const CounterCard({
    super.key,
    required this.counter,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
                counter.name
            ),
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
                counter.count.toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              FloatingActionButton(
                onPressed: onIncrement,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
          alignment: Alignment.centerRight,
          child: IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Delete Counter',
          onPressed: onDelete,
          ),
          ),
        ],
      ),
    );
  }
}
