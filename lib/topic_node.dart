class TopicNode {
  final String topic;
  final String description;
  final List<TopicNode> subtopics;

  const TopicNode(this.topic, this.subtopics, this.description);
}
