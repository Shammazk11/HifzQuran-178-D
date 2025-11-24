import 'package:flutter/material.dart';

class PerformanceDashboardPage extends StatelessWidget {
  final Map<String, dynamic> session;

  const PerformanceDashboardPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final performanceHistory = session['performanceHistory'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Performance History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.teal.shade50, Colors.white],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: performanceHistory.isEmpty
                ? _buildEmptyState()
                : _buildPerformanceList(performanceHistory),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 60, color: Colors.teal[700]),
          const SizedBox(height: 16),
          const Text(
            'No Performance History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start recording to track your progress!',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceList(List<dynamic> performanceHistory) {
    return ListView.builder(
      itemCount: performanceHistory.length,
      itemBuilder: (context, index) {
        final entry = performanceHistory[index] as Map<String, dynamic>;
        // Fix the errorRate handling to properly handle both int and double
        final dynamic rawErrorRate = entry['errorRate'];
        final String errorRate;
        if (rawErrorRate is int) {
          errorRate = (rawErrorRate.toDouble()).toStringAsFixed(2);
        } else if (rawErrorRate is double) {
          errorRate = rawErrorRate.toStringAsFixed(2);
        } else {
          errorRate = 'N/A';
        }
        final segmentIndex = entry['segmentIndex'] as int? ?? 0;
        final isCombinedPhase = entry['isCombinedPhase'] as bool? ?? false;
        final timestamp = DateTime.parse(entry['timestamp'] as String? ?? '').toLocal();
        final correctness = entry['correctness'] as List<dynamic>? ?? [];

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isCombinedPhase
                          ? 'Combined Practice'
                          : 'Ayah ${segmentIndex + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    Text(
                      'Error Rate: $errorRate',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: ${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                _buildCorrectnessSummary(correctness),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCorrectnessSummary(List<dynamic> correctness) {
    final totalWords = correctness.length;
    final correctWords = correctness.where((c) => c == true).length;
    final percentage = totalWords > 0 ? (correctWords / totalWords * 100).toStringAsFixed(1) : '0.0';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Accuracy: $percentage%',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.teal,
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green[700],
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '$correctWords/$totalWords',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    );
  }
}