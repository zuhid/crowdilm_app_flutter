import 'package:crowdilm/controls/my_dropdown_item.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyDropdown extends StatefulWidget {
  final String label;
  final Future<List<MyDropdownItem>>? futureData;
  final ValueChanged<String>? onChanged;
  String? selectedValue;

  MyDropdown({super.key, required this.label, this.selectedValue, required this.futureData, this.onChanged});

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  List<DropdownMenuItem<String>> _items(List<MyDropdownItem>? myDropdownItems) {
    if (myDropdownItems != null) {
      return myDropdownItems.map((item) => DropdownMenuItem(value: item.value, child: Text(item.text))).toList();
    }
    return <DropdownMenuItem<String>>[];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.label, style: TextStyle(color: Colors.white, fontFamily: 'Scheherazade', fontSize: 25)),
        FutureBuilder(
          future: widget.futureData,
          builder: (context, snapshot) => Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.black,
            ),
            child: DropdownButton<String>(
              items: _items(snapshot.data),
              value: widget.selectedValue,
              style: TextStyle(color: Colors.white, fontFamily: 'Scheherazade', fontSize: 25),
              onChanged: (String? value) => setState(() {
                widget.selectedValue = value ?? '';
                widget.onChanged!(widget.selectedValue ?? '');
              }),
            ),
          ),
        )
      ],
    );
  }
}
