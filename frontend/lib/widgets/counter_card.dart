import 'package:counter_flutter/models/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CounterCard extends StatefulWidget {
  final Counter counter;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;
  final void Function(int) onSetValue;

  const CounterCard({
    super.key,
    required this.counter,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
    required this.onSetValue,

  });

  @override
  State<CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<CounterCard> {
  bool _editing = false;
  late final TextEditingController _ctrl =
  TextEditingController(text: widget.counter.count.toString());
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus && _editing) _commit(); // auto-save on blur
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

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
            child: Text(widget.counter.name),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: widget.onDecrement,
                tooltip: 'Decrement',
                child: const Icon(Icons.remove),
              ),
              _editing ? _buildEditor(context) : _buildDisplay(context),
              FloatingActionButton(
                onPressed: widget.onIncrement,
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
              onPressed: widget.onDelete,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplay(BuildContext ctx) => GestureDetector(
    onTap: () {
      setState(() => _editing = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focus.requestFocus();
        _ctrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _ctrl.text.length,
        );
      });
    },
    child: Text(
      widget.counter.count.toString(),
      style: Theme.of(ctx).textTheme.headlineMedium,
    ),
  );

  Widget _buildEditor(BuildContext ctx) => SizedBox(
    width: 80,
    child: TextField(
      controller: _ctrl,
      focusNode: _focus,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      onSubmitted: (_) => _commit(),
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        border: OutlineInputBorder(),
      ),
    ),
  );

  void _commit() {
    final v = int.tryParse(_ctrl.text);
    if (v != null && v != widget.counter.count) widget.onSetValue(v);
    setState(() => _editing = false);
  }
}

