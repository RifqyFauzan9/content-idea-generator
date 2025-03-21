import 'package:flutter/material.dart';
import 'package:schedule_generator/screen/detail/detail_screen.dart';
import 'package:schedule_generator/services/shared_preferences_service.dart';
import 'package:schedule_generator/size_config.dart';
import 'package:schedule_generator/theme/color.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> historyList = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      isLoading = true;
    });
    try {
      final history = await HistoryService.getHistory();
      setState(() {
        historyList = history;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error loading history: $e");
    }
  }

  Future<void> _deleteHistoryItem(int index) async {
    try {
      await HistoryService.deleteHistory(index);
      _loadHistory();
    } catch (e) {
      debugPrint('error deleting item: $e');
    }
  }

  Future<void> _clearAllHistory() async {
    try {
      await HistoryService.clearHistory();
      _loadHistory();
    } catch (e) {
      debugPrint('error clearing all history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Disini ada history yow!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            if (historyList.isNotEmpty)
              IconButton(
                onPressed: () => _clearAllHistory(),
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
          ],
        ),
        body: historyList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied,
                      size: getPropScreenWidth(150),
                      color: kPrimaryColor,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    Text(
                      'Tidak ada history!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(30.0),
                child: ListView.builder(
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final item = historyList[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                data: item['content'] ?? {},
                                title: item['title'] ?? 'Tanpa Topic',
                              ),
                            ),
                          );
                        },
                        leading: Icon(
                          Icons.lightbulb,
                          color: kPrimaryColor,
                        ),
                        title: Text(item['title'] ?? 'Tanpa Topic'),
                        subtitle: Text(item['date'] ?? ''),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _deleteHistoryItem(index),
                        ),
                      ),
                    );
                  },
                ),
              ));
  }
}
