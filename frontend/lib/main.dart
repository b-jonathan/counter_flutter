// lib/main.dart
import 'dart:io';
import 'dart:convert';
import 'widgets/counter_dialog.dart';
import 'models/counter.dart';
import 'package:flutter/material.dart';
import 'widgets/counter_card.dart';
import 'services/counter.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final CounterService _service = CounterService();
  List<Counter> _counters = [];
  bool _loading = true;



  @override
  void initState() {
    super.initState();
    _loadCounters();
  }

  Future<void> _loadCounters() async {
    try {
        final counters = await _service.getCounters();
        setState(() {
          _counters = counters;
          _loading = false;
        });
    } catch (e) {

      setState(() {
        _counters = [];
        _loading = false;
      });
    }
  }

  void _addCounter(String name) async {
    final newCounter = await _service.createCounter(name);
    setState(() {
      _counters.add(newCounter);
    });
  }

  void _showCounterDialog() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const CounterDialog(),
    );
    if (name != null && name.trim().isNotEmpty) {
      _addCounter(name);
    }
  }




  Counter _getCounterById(String id) {
    return _counters.firstWhere((c) => c.id == id);
  }


  void _incrementCounter(String id) async {
    final counter = _getCounterById(id);
    setState(() {
      counter.count++;
    });
    await _service.updateCounter(counter);
  }

  void setCounter(String id, int count) async {
    final counter = _getCounterById(id);
    setState(() {
      counter.count = count;
    });
    await _service.updateCounter(counter);
  }

  void _decrementCounter(String id) async {
    final counter = _getCounterById(id);
    if (counter.count > 0) {
      setState(() {
        counter.count--;
      });
      await _service.updateCounter(counter);
    }
  }

  void _deleteCounter(Counter counter) async {
    setState(() {
      _counters.removeWhere((c) => c.id == counter.id);
    });
    await _service.deleteCounter(counter.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: _counters.map((counter) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                  child: CounterCard(
                    counter: counter,
                    onIncrement: () => _incrementCounter(counter.id),
                    onDecrement: () => _decrementCounter(counter.id),
                    onDelete: () => _deleteCounter(counter),
                    onSetValue: (val) => setCounter(counter.id,val),
                  ),
                ),
              );
            }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>_showCounterDialog(),
        tooltip: 'Add New Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
