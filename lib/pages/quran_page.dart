import 'package:crowdilm/controls/my_button.dart';
import 'package:crowdilm/main.dart';
import 'package:crowdilm/models/aya.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  int pageIndex = 1;
  List<Aya> getQuranLines() {
    var quranLines = crowdilmController.getAya(pageIndex);
    return quranLines;
  }

  List<_QuranItem> getQuranLines2() {
    var quranItems = <_QuranItem>[];
    var ayas = crowdilmController.getAya(pageIndex);
    var distinctLines = ayas.map((e) => e.lineId).toSet().toList();
    for (var line in distinctLines) {
      var quranArbic = ayas
          .where((n) => n.lineId == line && n.quranId == 'simple-clean')
          .first
          .text;
      var quranEnglish = ayas
          .where((n) => n.lineId == line && n.quranId == 'en.sahih')
          .first
          .text;
      var aya = ayas.where((n) => n.lineId == line).first;
      quranItems.add(_QuranItem(
          quranEnglish, quranArbic, '(${aya.surah}:${aya.ayaNumber})'));
    }

    return quranItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        body: Column(children: [
          Expanded(
              child: ListView(children: [
            for (var quranLine in getQuranLines2()) quranLine
          ])),
          Row(children: [
            MyButton('Previous', () => setState(() => pageIndex--)),
            MyButton('Settings', () => context.go('/setting')),
            MyButton('Next', () => setState(() => pageIndex++)),
          ])
        ]));
  }
}

class _QuranItem extends StatelessWidget {
  final String quran1;
  final String quran2;
  final String info;

  const _QuranItem(this.quran1, this.quran2, this.info);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          Text(quran1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Scheherazade',
                  fontSize: 30)),
          Text(
            quran2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Scheherazade',
              fontSize: 50,
            ),
          ),
          Text(info, style: TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}
