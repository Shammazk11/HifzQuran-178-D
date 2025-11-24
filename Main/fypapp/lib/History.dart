import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded performance data
    final List<Map<String, dynamic>> performanceData = [
      {
        'date': '2024-10-01',
        'ayahMemorized': 5,
        'ayahReviewed': 3,
        'performance': 'Good'
      },
      {
        'date': '2024-10-02',
        'ayahMemorized': 7,
        'ayahReviewed': 2,
        'performance': 'Excellent'
      },
      {
        'date': '2024-10-03',
        'ayahMemorized': 4,
        'ayahReviewed': 5,
        'performance': 'Satisfactory'
      },
      {
        'date': '2024-10-04',
        'ayahMemorized': 6,
        'ayahReviewed': 1,
        'performance': 'Good'
      },
      {
        'date': '2024-10-05',
        'ayahMemorized': 10,
        'ayahReviewed': 0,
        'performance': 'Excellent'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorization History'),
        backgroundColor: const Color(0xFF13A795),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: performanceData.length,
          itemBuilder: (context, index) {
            final data = performanceData[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${data['date']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text('Ayah Memorized: ${data['ayahMemorized']}'),
                    Text('Ayah Reviewed: ${data['ayahReviewed']}'),
                    Text('Performance: ${data['performance']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
