import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';

class CustomLoading extends StatefulWidget{

  @override
  _CustomLoading createState() => _CustomLoading();

}

class _CustomLoading extends State<CustomLoading> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: PlaceholderLines(
        count: 4,
        align: TextAlign.center,
        lineHeight: 8,
        color: Colors.blueAccent,
      ),
    );
  }
}

class SimpleTextPlaceholder extends StatefulWidget{
  @override
  _SimpleTextPlaceholder createState() => _SimpleTextPlaceholder();
}

class _SimpleTextPlaceholder extends State<SimpleTextPlaceholder>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: PlaceholderLines(
        count: 3,
        align: TextAlign.left,
      ),
    );
  }
}

class OneLineTextPlaceholder extends StatefulWidget{
  @override
  _OneLineTextPlaceholder createState() => _OneLineTextPlaceholder();
}

class _OneLineTextPlaceholder extends State<OneLineTextPlaceholder>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: PlaceholderLines(
        count: 1,
        align: TextAlign.left,
      ),
    );
  }
}

class SubtitlePlaceholder extends StatefulWidget{
  final String title;
  //SubtitlePlaceholder({Key? key,this.title}) : super(key: key);
  SubtitlePlaceholder({this.title});
  @override
  _SubtitlePlaceholder createState() => _SubtitlePlaceholder();
}

class _SubtitlePlaceholder extends State<SubtitlePlaceholder>{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 24,
        bottom: 16,
      ),
      child: Text(
        widget.title,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class ColorSizePlaceholder extends StatefulWidget{
  @override
  _ColorSizePlaceholder createState() => _ColorSizePlaceholder();
}

class _ColorSizePlaceholder extends State<ColorSizePlaceholder>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: PlaceholderLines(
        count: 4,
        align: TextAlign.center,
        lineHeight: 8,
        color: Colors.blueAccent,
      ),
    );
  }
}

class AnimatedPlaceholder extends StatefulWidget{
  @override
  _AnimatedPlaceholder createState() => _AnimatedPlaceholder();
}

class _AnimatedPlaceholder extends State<AnimatedPlaceholder>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: PlaceholderLines(
        count: 3,
        animate: true,
        color: Colors.grey,
      ),
    );
  }
}

class CardPlaceholder extends StatefulWidget{
  @override
  _CardPlaceholder createState() => _CardPlaceholder();
}

class _CardPlaceholder extends State<CardPlaceholder>{
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 9,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        width: 300,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16),
              width: 70,
              height: 70,
              decoration: BoxDecoration(color: Colors.grey.withOpacity(.6), ),
              child: Center(child: Icon(Icons.photo_size_select_actual, color: Colors.white, size: 38,),),
            ),
            Expanded(
              child: PlaceholderLines(
                count: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}