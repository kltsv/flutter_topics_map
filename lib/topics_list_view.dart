import 'package:flutter/material.dart';

import 's.dart';
import 'topic_node.dart';
import 'topic_page.dart';

class TopicsListView extends StatelessWidget {
  final String? topicDescription;
  final List<TopicNode> topics;

  const TopicsListView({
    Key? key,
    required this.topics,
    this.topicDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final description = topicDescription;
        if (description != null && index == 0) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description),
          );
        }
        return TopicTile(
          topicNode: topics[index - (description != null ? 1 : 0)],
        );
      },
      itemCount: topics.length + (topicDescription != null ? 1 : 0),
    );
  }
}

class TopicTile extends StatelessWidget {
  final TopicNode topicNode;

  const TopicTile({
    Key? key,
    required this.topicNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: HeroTopicTitle(topicNode: topicNode),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(topicNode.description),
            Wrap(
              children: topicNode.subtopics
                  .map(
                    (subtopic) => TopicChip(topic: subtopic),
                  )
                  .toList(),
            ),
          ],
        ),
        onTap: topicNode.subtopics.isNotEmpty
            ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopicPage(topic: topicNode),
                  ),
                )
            : null,
      ),
    );
  }
}

class HeroTopicTitle extends StatelessWidget {
  final TopicNode topicNode;

  const HeroTopicTitle({
    Key? key,
    required this.topicNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: topicNode.topic,
      child: Material(
        color: Colors.transparent,
        child: Text(
          S.of(context).get(topicNode.topic),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class TopicChip extends StatelessWidget {
  final TopicNode topic;

  const TopicChip({
    required this.topic,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor.withOpacity(0.2),
      ),
      margin: const EdgeInsets.all(2.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: Text(
          S.of(context).get(topic.topic),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
