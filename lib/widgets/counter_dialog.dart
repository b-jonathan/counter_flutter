import 'package:counter_flutter/models/counter.dart';
import 'package:flutter/material.dart';

class CounterDialog extends StatefulWidget {
  const CounterDialog({super.key});

  @override
  State<CounterDialog> createState() => _CounterDialoglState();
}

class _CounterDialoglState extends State<CounterDialog>{
  String _counterName = '';

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: const Text('What are you counting?'),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Counter Name',
          border: OutlineInputBorder(),
        ),
        onChanged: (value){
          setState((){
            _counterName = value;
          });
        }
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel')
        ),
        ElevatedButton(onPressed: () =>Navigator.of(context).pop(_counterName),
            child: const Text('Add'),
        ),
      ],
    );
  }
}