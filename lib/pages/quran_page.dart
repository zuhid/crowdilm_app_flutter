import 'package:crowdilm/extensions/string_extension.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:crowdilm/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  Map<String, String> _settings = {};
  int pageIndex = 1;

  _QuranPageState() {
    _settings = crowdilmController.getSettings();
  }

  List<_QuranItem> getQuranLines() {
    var quranItems = <_QuranItem>[];
    pageIndex = int.parse(_settings['pageIndex'] ?? '1');
    var ayas = crowdilmController.getAya(_settings['paging'] ?? 'page', pageIndex);
    var distinctLines = ayas.map((e) => e.lineId).toSet().toList();
    for (var line in distinctLines) {
      var quran1 = ayas.where((n) => n.lineId == line && n.quranId == _settings['quran1']).first.text;
      var quran2 = ayas.where((n) => n.lineId == line && n.quranId == _settings['quran2']).first.text;
      quran1 = parseFragment(quran1).text ?? "";
      quran2 = parseFragment(quran2).text ?? "";
      var aya = ayas.where((n) => n.lineId == line).first;
      quranItems.add(_QuranItem(quran1, _settings['quran1Size'] ?? "10", quran2, _settings['quran2Size'] ?? "10", aya.surah, aya.ayaNumber));
    }

    return quranItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.0, semanticLabel: 'Settings'),
                  onPressed: () => setState(() {
                        pageIndex++;
                        _settings['pageIndex'] = pageIndex.toString();
                        crowdilmController.saveSettings(_settings);
                      })),
              Text('${_settings['paging']?.capitalize() ?? ''}  ', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
              SizedBox(
                width: 40,
                height: 45,
                child: TextFormField(
                  key: Key('page$pageIndex'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                  decoration: const InputDecoration(fillColor: Colors.white),
                  initialValue: pageIndex.toString(),
                  onChanged: (value) => setState(() {
                    pageIndex = int.tryParse(value) ?? 0;
                    _settings['pageIndex'] = pageIndex.toString();
                    crowdilmController.saveSettings(_settings);
                  }),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.white, size: 24.0, semanticLabel: 'Settings'),
                  onPressed: () => setState(() {
                        pageIndex--;
                        _settings['pageIndex'] = pageIndex.toString();
                        crowdilmController.saveSettings(_settings);
                      })),
              IconButton(
                  icon: Icon(Icons.settings, color: Colors.white, size: 24.0, semanticLabel: 'Settings'), onPressed: () => context.go('/setting')),
            ],
          ),
          Expanded(
            child: ListView(
              key: Key(pageIndex.toString()),
              children: [for (var quranLine in getQuranLines()) quranLine],
            ),
          ),
        ]));
  }
}

class _QuranItem extends StatelessWidget {
  final String quran1;
  final String quran1Size;
  final String quran2;
  final String quran2Size;
  final int surah;
  final int ayaNumber;

  const _QuranItem(this.quran1, this.quran1Size, this.quran2, this.quran2Size, this.surah, this.ayaNumber);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(1.5),
      child: Column(
        children: [
          if (surah != 9 && ayaNumber == 1)
            Text('بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontFamily: 'Scheherazade', fontSize: double.parse(quran1Size))),
          Text(quran1,
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontFamily: 'Scheherazade', fontSize: double.parse(quran1Size))),
          Text(
            quran2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Scheherazade',
              fontSize: double.parse(quran2Size),
            ),
          ),
          Text('($surah:$ayaNumber)', style: TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}
