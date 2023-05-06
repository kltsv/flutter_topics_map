import 'package:flutter/material.dart';

import 'topic_node.dart';
import 'topic_page.dart';

class TopicsListView extends StatelessWidget {
  final List<TopicNode> topics;

  const TopicsListView({
    Key? key,
    required this.topics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(topics[index].topic),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopicPage(topic: topics[index]),
          ),
        ),
      ),
      itemCount: topics.length,
    );
  }
}
