import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'doc.dart';
import 'topic_node.dart';
import 'topics_list_view.dart';
import 'topics_parser.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TopicNode>? topics;

  @override
  void initState() {
    super.initState();
    _initMatrix().then((topics) => setState(() => this.topics = topics));
  }

  @override
  Widget build(BuildContext context) {
    final list = topics;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Dev Topics'),
      ),
      body: list != null
          ? TopicsListView(topics: list)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<List<TopicNode>> _initMatrix() async {
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

    final topLevelTopics = TopicsParser.parseTopics(skillsMap.content);
    TopicsParser.printTopicsTree(topLevelTopics);
    return topLevelTopics;
  }
}
