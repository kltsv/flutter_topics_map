import 'topic_node.dart';

class TopicsParser {
  static List<TopicNode> parseTopics(String string) {
    List<String> lines = string.split('\n');
    return _parseTopicNodes(lines, 0, 0).nodes;
  }

  static _ParsedTopicNodes _parseTopicNodes(
      List<String> lines, int lineIndex, int indentLevel) {
    List<TopicNode> nodes = [];

    while (lineIndex < lines.length) {
      String line = lines[lineIndex];
      int currentIndentLevel = _getIndentLevel(line);

      if (currentIndentLevel < indentLevel) {
        break;
      } else if (currentIndentLevel == indentLevel) {
        nodes.add(TopicNode(line.replaceAll('-', '').trim(), []));
        lineIndex++;
      } else {
        TopicNode lastNode = nodes.last;
        _ParsedTopicNodes result =
            _parseTopicNodes(lines, lineIndex, currentIndentLevel);
        lastNode.subtopics.addAll(result.nodes);
        lineIndex = result.endIndex;
      }
    }

    return _ParsedTopicNodes(nodes, lineIndex);
  }

  static int _getIndentLevel(String line) {
    int i = 0;
    while (i < line.length && line[i] == ' ') {
      i++;
    }
    return i ~/ 2;
  }

  static void printTopicsTree(List<TopicNode> topics) {
    for (TopicNode topic in topics) {
      _printTopicNode(topic, 0);
    }
  }

  static void _printTopicNode(TopicNode node, int depth) {
    String prefix = '${'  ' * depth}- ';
    // ignore: avoid_print
    print('$prefix${node.topic}');
    for (final subtopic in node.subtopics) {
      _printTopicNode(subtopic, depth + 1);
    }
  }

  const TopicsParser._();
}

class _ParsedTopicNodes {
  final List<TopicNode> nodes;
  final int endIndex;

  const _ParsedTopicNodes(this.nodes, this.endIndex);
}
