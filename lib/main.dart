// lib/main.dart
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:counter_flutter/models/counter.dart';
import 'package:flutter/material.dart';
import 'widgets/counter_card.dart';

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
  List<Counter> _counters = [];
  int _nextId = 0;

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/counters.json');
  }

  Future<void> _saveCountersToFile() async {
    final file = await _getLocalFile();
    final data = _counters.map((c) => c.toJson()).toList();
    await file.writeAsString(jsonEncode(data));
  }

  Future<void> _loadCountersFromFile() async {
    try {
      final file = await _getLocalFile();
      final raw = await file.readAsString();
      final jsonList = jsonDecode(raw) as List;
      setState(() {
        _counters = jsonList.map((e) => Counter.fromJson(e)).toList();
        _nextId = _counters.isEmpty
            ? 0
            : _counters.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
      });
    } catch (e) {
      _counters = [];
      _nextId = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCountersFromFile();
  }

  void _addCounter(){
    setState(() {
      _counters.add(Counter(id: _nextId, name: 'Counter ${_nextId + 1}'));
      _nextId++;
    });
    _saveCountersToFile();
  }

  void _deleteCounter(Counter counter){
    setState(() {
      _counters.remove(counter);
    });
    _saveCountersToFile();
  }

  Counter _getCounterById(int id) {
    return _counters.firstWhere((c) => c.id == id);
  }

  void _incrementCounter(int id) {
    final counter = _getCounterById(id);
    setState(()  {
      counter.count++;
    });
    _saveCountersToFile();
  }

  void _decrementCounter(int id) {
    final counter = _getCounterById(id);
    setState(() {
      counter.count--;
    });
    _saveCountersToFile();
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
                  ),
                ),
              );
            }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>_addCounter(),
        tooltip: 'Add New Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
