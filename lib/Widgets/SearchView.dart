import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next page'),
      ),
      body: const Center(
        child: Text(
          'This is the next page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
