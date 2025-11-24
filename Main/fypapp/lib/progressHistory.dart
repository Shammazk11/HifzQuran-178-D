import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fypapp/provider.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class ProgressHistoryPage extends StatefulWidget {
  const ProgressHistoryPage({super.key});

  @override
  ProgressHistoryPageState createState() => ProgressHistoryPageState();
}

class ProgressHistoryPageState extends State<ProgressHistoryPage> {
  List<Map<String, dynamic>> goalProgress = []; // Change from Map to List
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGoalProgress();
  }

  Future<void> fetchGoalProgress() async {
    final email = Provider.of<UserProvider>(context, listen: false).email;
    const String apiUrl = "${AppConfig.baseUrl}/goal-progress";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          goalProgress = List<Map<String, dynamic>>.from(
              data); // Convert the response to a List
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("Failed to fetch progress: ${response.body}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching progress: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress History"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : goalProgress.isEmpty
              ? const Center(
                  child: Text(
                    "No progress history available.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: goalProgress.length, // Adjusted for List
                  itemBuilder: (context, index) {
                    final progress =
                        goalProgress[index]; // Accessing data from the List

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Goal ID: ${progress['goalId'].substring(0, 6).toUpperCase()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildStatCard("Total Sessions",
                                    progress['totalSessions']),
                                const SizedBox(width: 12),
                                _buildStatCard("Completed Sessions",
                                    progress['completedSessions']),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildStatCard(
                                    "Daily Time", progress['dailyTime']),
                                const SizedBox(width: 12),
                                _buildStatCard("Progress %",
                                    progress['progressPercentage']),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildStatCard(String title, dynamic value) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        color: Colors.teal.shade50,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                value.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
