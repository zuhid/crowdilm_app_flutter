import 'package:crowdilm/models/aya.dart';
import 'package:crowdilm/models/quran_line.dart';
import 'package:crowdilm/models/setting.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path_provider/path_provider.dart';
import '../models/line.dart';
import '../models/quran.dart';
import '../models/sura.dart';

class CrowdilmDatabase {
  String directory = '';
  Database? database;

  Future open() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    database = sqlite3.open('$directory/crowdilm.db');
    buildLine();
    buildQuran();
    buildQuranLine();
    buildSura();
    buildSetting();
  }

  buildLine() {
    database!.execute('drop table if exists line;');
    database!.execute('''create table if not exists line(
  id integer not null
, surah integer not null
, aya integer not null
, manzil integer not null
, juz integer not null
, hizb integer not null
, ruku integer not null
, page integer not null
, primary key(id)
);''');
  }

  buildQuran() {
    database!.execute('''create table if not exists quran(
  id text not null
, language text not null
, name text not null
, name_english text not null
, quran_type text not null
, primary key(id)
);''');
  }

  buildQuranLine() {
    database!.execute('''create table if not exists quran_line (
  quran_id text not null
, line_id integer not null
, text text not null
, primary key(quran_id, line_id)
, constraint fk_quran_quran_id_quran_id foreign key (quran_id) REFERENCES quran(id)
, constraint fk_line_line_id_line_id foreign key (line_id) REFERENCES line(id)
);''');
  }

  buildSura() {
    database!.execute('''create table if not exists sura(
  id integer not null
, ayas integer not null
, name_arabic text not null
, name_english text not null
, revelation_city text not null
, revelation_order integer not null
, primary key(id)
);''');
  }

  buildSetting() {
    database!.execute('''create table if not exists setting(
  id integer not null
, quran1 text not null
, quran2 text not null
, primary key(id)
);''');
  }

  addQurans(List<Quran> qurans) {
    var query = database!.prepare(
        'insert or ignore into quran(id, language, name, name_english, quran_type) values (?,?,?,?,?);');
    for (var quran in qurans) {
      query.execute([
        quran.id,
        quran.language,
        quran.name,
        quran.nameEnglish,
        quran.quranType
      ]);
    }
  }

  List<Quran> getQurans() {
    var resultSet = database!.select('select * from quran');
    List<Quran> qurans = [];
    for (var result in resultSet) {
      qurans.add(Quran(result['id'], result['language'], result['name'],
          result['name_english'], result['quran_type']));
    }
    return qurans;
  }

  addLines(List<Line> lines) {
    const queryString =
        'insert or ignore into line(id, surah, aya, manzil, juz, hizb, ruku, page) values ';
    var query = StringBuffer(queryString);

    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      query.write(
          '(${line.id},${line.surah},${line.aya},${line.manzil},${line.juz},${line.hizb},${line.ruku},${line.page})');
      if (i % 100 == 0 || i == lines.length - 1) {
        database!.execute('${query.toString()};');
        query = StringBuffer(queryString);
      } else if (i % 100 != 0) {
        query.write(',');
      }
    }
  }

  List<Line> getLines() {
    var resultSet = database!.select('select * from line');
    List<Line> lines = [];
    for (var result in resultSet) {
      lines.add(Line(
          result['id'],
          result['surah'],
          result['aya'],
          result['manzil'],
          result['juz'],
          result['hizb'],
          result['ruku'],
          result['page']));
    }
    return lines;
  }

  addQuranLines(List<QuranLine> quranlines) {
    const queryString =
        'insert or ignore into quran_line(quran_id, line_id, text) values ';
    var query = StringBuffer(queryString);

    for (var i = 0; i < quranlines.length; i++) {
      var line = quranlines[i];
      query.write("('${line.quranId}','${line.lineId}','${line.text}')");
      if (i % 100 == 0 || i == quranlines.length - 1) {
        database!.execute('${query.toString()};');
        query = StringBuffer(queryString);
      } else if (i % 100 != 0) {
        query.write(',');
      }
    }
  }

  List<QuranLine> getQuranLines(String quranId) {
    var resultSet = database!
        .select('select * from quran_line where quran_id=?', [quranId]);
    List<QuranLine> quranlines = [];
    for (var result in resultSet) {
      quranlines.add(
          QuranLine(result['quran_id'], result['line_id'], result['text']));
    }
    return quranlines;
  }

  List<Aya> getAya(int pageId) {
    var resultSet = database!.select('''
select
  quran_line.quran_id
, quran_line.line_id
, line.surah
, line.aya
, quran_line.text
from quran_line
	inner join line on quran_line.line_id = line.id
where line.hizb = ?
order by quran_line.line_id
''', [pageId]);
    List<Aya> ayas = [];
    for (var result in resultSet) {
      ayas.add(Aya(result['quran_id'], result['line_id'], result['surah'],
          result['aya'], result['text']));
    }
    return ayas;
  }

  addSuras(List<Sura> suras) {
    var query = database!.prepare(
        'insert or ignore into sura(id, ayas, name_arabic, name_english, revelation_city, revelation_order) values (?,?,?,?,?,?);');
    for (var sura in suras) {
      query.execute([
        sura.id,
        sura.ayas,
        sura.nameArabic,
        sura.nameEnglish,
        sura.revelationCity,
        sura.revelationOrder
      ]);
    }
  }

  List<Sura> getSuras() {
    var resultSet = database!.select('select * from sura');
    List<Sura> suras = [];
    for (var result in resultSet) {
      suras.add(Sura(
          result['id'],
          result['ayas'],
          result['name_arabic'],
          result['name_english'],
          result['revelation_city'],
          result['revelation_order']));
    }
    return suras;
  }

  void saveSetting(Setting setting) {
    database!.execute(
        'insert or replace into setting(id, quran1, quran2) values (?,?,?);',
        [1, setting.quran1, setting.quran2]);
  }
}
