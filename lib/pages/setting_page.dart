import 'dart:async';
import 'package:crowdilm/controls/my_button.dart';
import 'package:crowdilm/controls/my_dropdown.dart';
import 'package:crowdilm/controls/my_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Map<String, String> _settings = {};

  _SettingPageState() {
    _settings = crowdilmController.getSettings();
  }

  static Future<List<MyDropdownItem>> get qurans async {
    return (await crowdilmController.getQurans())
        .map<MyDropdownItem>((quran) => MyDropdownItem(quran.id, '${quran.language} - ${quran.name}'))
        .toList();
  }

  static Future<List<MyDropdownItem>> get paging async {
    return Future.value([
      MyDropdownItem('surah', 'Surah'),
      MyDropdownItem('page', 'Page'),
      MyDropdownItem('ruku', 'Ruku'),
      MyDropdownItem('hizb', 'Hizb'),
      MyDropdownItem('juz', 'Juz'),
      MyDropdownItem('manzil', 'Manzil'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        titleTextStyle: TextStyle(color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
      ),
      backgroundColor: const Color.fromARGB(255, 24, 24, 24),
      body: Column(children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              children: [
                MyDropdown(
                    label: 'Quran  ', selectedValue: _settings["quran1"], futureData: qurans, onChanged: (value) => _settings["quran1"] = value),
                Slider(
                    value: double.parse(_settings['quran1Size'] ?? '10.0'),
                    min: 0,
                    max: 100,
                    divisions: 25,
                    label: _settings['quran1Size'],
                    onChanged: (value) {
                      setState(() {
                        _settings["quran1Size"] = value.toString();
                      });
                    }),
                MyDropdown(
                    label: 'Quran  ', selectedValue: _settings["quran2"], futureData: qurans, onChanged: (value) => _settings["quran2"] = value),
                Slider(
                    value: double.parse(_settings['quran2Size'] ?? '10.0'),
                    min: 0,
                    max: 100,
                    divisions: 25,
                    label: _settings['quran2Size'],
                    onChanged: (value) {
                      setState(() {
                        _settings["quran2Size"] = value.toString();
                      });
                    }),
                MyDropdown(
                    label: 'Paging  ', selectedValue: _settings["paging"], futureData: paging, onChanged: (value) => _settings["paging"] = value),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.save, color: Colors.white, size: 24.0, semanticLabel: 'Settings'),
              onPressed: () async {
                crowdilmController.saveSettings(_settings);
                await crowdilmController.getQuranLines(_settings["quran1"]!);
                await crowdilmController.getQuranLines(_settings["quran2"]!);
                if (context.mounted) {
                  context.go('/quran');
                }
              },
            ),
          ],
        )
      ]),
    );
  }
}
