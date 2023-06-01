import 'dart:convert';

import 'package:flutter/services.dart';

import 'doc.dart';
import 'topic_node.dart';

class TopicsParser {
  static const _basePath = 'matrix';

  static Future<List<TopicNode>> initTopics() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final topicsPaths = manifestMap.keys.toList(growable: false);

    final topics = <String, Doc>{};
    for (final path in topicsPaths) {
      final content = await rootBundle.loadString(path);
      final topic = Doc(path, content);
      topics[topic.path] = topic;
    }

    final skillsMap = topics.remove('matrix/skills_map.md')!;

    final topLevelTopics = TopicsParser.parseTopics(
      skillsMap.content,
      topics,
    );
    TopicsParser.printTopicsTree(topLevelTopics);
    return topLevelTopics;
  }

  static List<TopicNode> parseTopics(
      String structure, Map<String, Doc> topics) {
    List<String> lines = structure.split('\n');
    return _parseTopicNodes(lines, 0, 0, topics).nodes;
  }

  static _ParsedTopicNodes _parseTopicNodes(
    List<String> lines,
    int lineIndex,
    int indentLevel,
    Map<String, Doc> topics,
  ) {
    List<TopicNode> nodes = [];

    while (lineIndex < lines.length) {
      String line = lines[lineIndex];
      int currentIndentLevel = _getIndentLevel(line);

      if (currentIndentLevel < indentLevel) {
        break;
      } else if (currentIndentLevel == indentLevel) {
        final topicKey = line.replaceAll('-', '').trim();
        nodes.add(TopicNode(
            topicKey, [], topics['$_basePath/$topicKey.md']!.content));
        lineIndex++;
      } else {
        TopicNode lastNode = nodes.last;
        _ParsedTopicNodes result =
            _parseTopicNodes(lines, lineIndex, currentIndentLevel, topics);
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
