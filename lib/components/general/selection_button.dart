import 'package:flutter/material.dart';
import '../../models/structures/constants.dart';

class SelectionButton extends StatefulWidget {
  final String firstChoice;
  final String secondChoice;
  const SelectionButton(
      {Key key, this.firstChoice = "Recommended For You", this.secondChoice = "Random"})
      : super(key: key);

  @override
  _SelectionButtonState createState() => _SelectionButtonState();
}


class _SelectionButtonState extends State<SelectionButton> {
  var firstSelection = true;

  Widget buttonLayout(BuildContext context, String option) {
    return Container(
      height: 55,
      width: 140,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          width: 2.0,
          color: Colors.redAccent,
        ),
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
      ),
      child: FittedBox(
        child: FlatButton(
          onPressed: () {
            setState(() {
          
              firstSelection = !firstSelection;
            });
          },
          child: Text(
            option,
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(color: textColor, fontSize: 40),
          ),
        ),
      ),
    );
  }

  Widget oppositeText(BuildContext context, String option) {
    return Container(
      height: 50,
      width: 70,
      child: FittedBox(
        child: FlatButton(
          onPressed: () {
            setState(() {
              firstSelection = !firstSelection;
            });
          },
          child: Text(
            option,
            style: Theme.of(context)
                .textTheme
                .body2
                .copyWith(color: unselectedTextColor, fontSize: 28),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 34,
        width: 220,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
          border: Border.all(
            width: 2.0,
            color: Theme.of(context).buttonColor,//kinda redundant
          ),
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        child: Row(
          children: <Widget>[
            firstSelection
                ? buttonLayout(context, widget.firstChoice)
                : oppositeText(context, widget.firstChoice),
            !firstSelection
                ? buttonLayout(context, widget.secondChoice)
                : oppositeText(context, widget.secondChoice),
          ],
        ));
  }
}
