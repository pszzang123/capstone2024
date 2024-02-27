import 'package:flutter/material.dart';

class man extends StatefulWidget {
  const man({super.key});

  @override
  State<man> createState() => _manState();
}

class _manState extends State<man> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('남성'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text('남성페이지',)
        ],
      ),
    );
  }
}
