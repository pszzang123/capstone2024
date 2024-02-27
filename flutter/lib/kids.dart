import 'package:flutter/material.dart';

class kids extends StatefulWidget {
  const kids({super.key});

  @override
  State<kids> createState() => _kidsState();
}

class _kidsState extends State<kids> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('키즈'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text('키즈페이지',)
        ],
      ),
    );
  }
}
