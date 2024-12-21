import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, dynamic>? data;
  const ResultsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null || data!['error'] != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Results')),
        body: Center(child: Text('No data found or error occurred. Check connection or try again.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Results')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Food: ${data!['foodName']}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Carbs: ${data!['carbs']} g'),
            Text('Protein: ${data!['protein']} g'),
            Text('Fat: ${data!['fat']} g'),
          ],
        ),
      ),
    );
  }
}