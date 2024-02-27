import 'package:flutter/material.dart';

class bagAndShoes extends StatefulWidget {
  const bagAndShoes({super.key});

  @override
  State<bagAndShoes> createState() => _bagAndShoesState();
}

class _bagAndShoesState extends State<bagAndShoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('백&슈즈'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text('백&슈즈',)
        ],
      ),
    );
  }
}
