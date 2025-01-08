import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/line.dart';
import '../models/quran.dart';
import '../models/quran_line.dart';
import '../models/sura.dart';

class QuranApi {
  static const _baseurl = "www.crowdilm.com";

  dynamic _get(String url, {Map<String, dynamic>? params}) async {
    return json.decode(await http.read(Uri.http(_baseurl, url, params)));
  }

  Future<List<Line>> getLines() async {
    var responseList = await _get('api/line.php');
    List<Line> lines = [];
    responseList.forEach((item) => lines.add(Line.fromJson(item)));
    return lines;
  }

  Future<List<Quran>> getQurans() async {
    var responseList = await _get('api/quran.php');
    List<Quran> qurans = [];
    responseList.forEach((item) => qurans.add(Quran.fromJson(item)));
    return qurans;
  }

  Future<List<QuranLine>> getQuranLines(String quranId) async {
    var responseList = await _get('api/quranline.php', params: {"quran_id": quranId});
    List<QuranLine> quranLines = [];
    responseList.forEach((item) => quranLines.add(QuranLine.fromJson(quranId, item)));
    return quranLines;
  }

  Future<List<Sura>> getSuras() async {
    var responseList = await _get('api/sura.php');
    List<Sura> suras = [];
    responseList.forEach((item) => suras.add(Sura.fromJson(item)));
    return suras;
  }
}
