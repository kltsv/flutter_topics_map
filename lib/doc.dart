class Doc {
  final String path;
  final String content;

  const Doc(this.path, this.content);

  @override
  String toString() => '$path: $content';
}
