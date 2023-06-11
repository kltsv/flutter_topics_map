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
    final descriptionOffset = topicDescription != null ? 1 : 0;
    final hasDescription = topicDescription != null;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListView.builder(
          itemBuilder: (context, index) {
            final description = topicDescription;
            if (description != null && index == 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(description),
              );
            }
            final clipRadius = hasDescription
                ? null
                : index == 0
                    ? const BorderRadius.vertical(top: Radius.circular(12))
                    : index == (topics.length - 1)
                        ? const BorderRadius.vertical(
                            bottom: Radius.circular(12))
                        : null;

            final tile = Dismissible(
              key: ValueKey(
                topics[index - descriptionOffset].topic,
              ),
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: clipRadius,
                  color: Colors.red,
                ),
              ),
              child: TopicTile(
                topicNode: topics[index - descriptionOffset],
                borderRadius: clipRadius,
              ),
            );

            return tile;
          },
          itemCount: topics.length + descriptionOffset,
        ),
      ),
    );
  }
}

class TopicTile extends StatelessWidget {
  final TopicNode topicNode;
  final BorderRadiusGeometry? borderRadius;

  const TopicTile({
    Key? key,
    required this.topicNode,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      title: HeroTopicTitle(topicNode: topicNode),
      shape:
          radius != null ? RoundedRectangleBorder(borderRadius: radius) : null,
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
