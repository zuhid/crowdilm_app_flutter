import 'dart:async';
import 'package:crowdilm/controls/my_button.dart';
import 'package:crowdilm/controls/my_dropdown.dart';
import 'package:crowdilm/controls/my_dropdown_item.dart';
import 'package:crowdilm/models/setting.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var quranList = <String>['quran 1', 'quran 2'];

  static Future<List<MyDropdownItem>> get qurans async {
    return (await crowdilmController.getQurans())
        .map<MyDropdownItem>((quran) => MyDropdownItem(quran.id, quran.name))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Setting")),
      body: ListView(children: [
        // for (var quran in quranList)
        //   MyDropdown(label: quran, futureData: qurans),
        MyDropdown(label: 'Quran', futureData: qurans),
        MyButton('Save', () {
          crowdilmController.saveSetting(Setting('en.sahih', 'simple-clean'));
          context.go('/quran');
        }),
      ]),
    );
  }
}
