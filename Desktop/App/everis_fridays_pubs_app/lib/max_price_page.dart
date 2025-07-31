import 'package:flutter/material.dart';

class MaxPricePage extends StatefulWidget {
  final int? currentMaxPrice;

  const MaxPricePage(this.currentMaxPrice, {Key? key}) : super(key: key);

  @override
  State<MaxPricePage> createState() => _MaxPricePageState();
}

class _MaxPricePageState extends State<MaxPricePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.currentMaxPrice?.toString() ?? '15'); // default 15
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final int? maxPrice = int.tryParse(_controller.text);
    Navigator.pop(context, maxPrice ?? 15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Max Price'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Max price',
                hintText: 'Enter max price',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Apply Filter', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}