class Sura {
  int id;
  int ayas;
  String nameArabic;
  String nameEnglish;
  String revelationCity;
  int revelationOrder;

  Sura(this.id, this.ayas, this.nameArabic, this.nameEnglish,
      this.revelationCity, this.revelationOrder);

  Sura.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        ayas = int.parse(json['ayas']),
        nameArabic = json['name_arabic'] as String,
        nameEnglish = json['name_english'] as String,
        revelationCity = json['revelation_city'] as String,
        revelationOrder = int.parse(json['revelation_order']);
}
