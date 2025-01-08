class Quran {
  String id;
  String language;
  String name;
  String nameEnglish;
  String quranType;

  Quran(this.id, this.language, this.name, this.nameEnglish, this.quranType);

  Quran.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        language = json['language'] as String,
        name = json['name'] as String,
        nameEnglish = json['name_english'] as String,
        quranType = json['quran_type'] as String;
}
