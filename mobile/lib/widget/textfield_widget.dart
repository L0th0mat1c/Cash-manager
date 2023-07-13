import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;




  const TextFieldWidget({
    Key key,
    this.maxLines = 1,
    @required this.label,
    @required this.text,
    @required this.onChanged
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  TextEditingController controller;

  

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }
  @override
  void dispose(){
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.label,
        style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold   
                )
      ),
      const SizedBox(height: 5),
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          ),
        maxLines: widget.maxLines,
        onChanged: (value) => widget.onChanged(value),
      )

    ]);
}