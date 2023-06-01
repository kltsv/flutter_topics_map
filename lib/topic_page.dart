import 'package:flutter/material.dart';

import 'topic_node.dart';
import 'topics_list_view.dart';

class TopicPage extends StatelessWidget {
  final TopicNode topic;

  const TopicPage({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeroTopicTitle(topicNode: topic),
      ),
      body: TopicsListView(
        topicDescription: topic.description,
        topics: topic.subtopics,
      ),
    );
  }
}
