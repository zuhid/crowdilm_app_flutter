class Line {
  int id;
  int surah;
  int aya;
  int manzil;
  int juz;
  int hizb;
  int ruku;
  int page;

  Line(this.id, this.surah, this.aya, this.manzil, this.juz, this.hizb,
      this.ruku, this.page);

  Line.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        surah = int.parse(json['surah']),
        aya = int.parse(json['aya']),
        manzil = int.parse(json['manzil']),
        juz = int.parse(json['juz']),
        hizb = int.parse(json['hizb']),
        ruku = int.parse(json['ruku']),
        page = int.parse(json['page']);
}
