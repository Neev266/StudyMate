class Note{
  final String id;
  final String title;
  final String content;
  final List<Attachment> attachments;
  final String createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.attachments,
    required this.createdAt,
  });

  factory Note.fromMap(String id, Map<String, dynamic> map) {
    return Note(
      id: id,
      title: map['title'],
      content: map['content'],
      attachments: (map['attachments'] as List? ?? [])
          .map((e) => Attachment.fromMap(e))
          .toList(),
      createdAt: map['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'attachments': attachments.map((e) => e.toMap()).toList(),
      'createdAt': createdAt,
    };
  }
}

class Attachment {
  final String url;
  final String type; // image | pdf

  Attachment({required this.url, required this.type});

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      url: map['url'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'type': type,
    };
  }
}
