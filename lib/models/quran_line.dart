class QuranLine {
  String quranId;
  int lineId;
  String text;

  QuranLine(this.quranId, this.lineId, this.text);

  QuranLine.fromJson(this.quranId, Map<String, dynamic> json)
      : lineId = int.parse(json['line_id']),
        text = json['text'] as String;
}
