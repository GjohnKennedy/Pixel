import 'package:flutter/material.dart';

class RadioButtonPage extends StatefulWidget {
  @override
  _RadioButtonPageState createState() => _RadioButtonPageState();
}

class _RadioButtonPageState extends State<RadioButtonPage> {
  bool _isSelected = false;
  // static bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CustomRadioButton(
          label: 'Select',
          isSelected: _isSelected,
          onSelect: (bool isSelected) {
            setState(() {
              _isSelected = isSelected;
            });
          },
        ),
      ),
    );
  }
}

class CustomRadioButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelect;

  CustomRadioButton(
      {required this.label, required this.isSelected, required this.onSelect});

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelect(!widget.isSelected);
      },
      child: Container(
        height: 30,
        child: Row(
          children: [
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isSelected ? Colors.red : Colors.transparent,
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: widget.isSelected
                  ? Center(
                      child: Icon(Icons.check, size: 14, color: Colors.black))
                  : null,
            ),
            SizedBox(width: 10),
            Text(
              widget.label,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
