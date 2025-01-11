import 'package:crowdilm/controls/my_dropdown_item.dart';
import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  final String label;
  final Future<List<MyDropdownItem>>? futureData;
  final ValueChanged<String>? onChanged;

  const MyDropdown({super.key, required this.label, required this.futureData, this.onChanged});

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String? _selectedValue;

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
        Text(widget.label),
        FutureBuilder(
            future: widget.futureData,
            builder: (context, snapshot) => DropdownButton<String>(
                  items: _items(snapshot.data),
                  value: _selectedValue,
                  onChanged: (String? value) => setState(() {
                    _selectedValue = value ?? '';
                    widget.onChanged!(_selectedValue ?? '');
                  }),
                ))
      ],
    );
  }
}
