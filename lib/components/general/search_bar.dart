import 'package:flutter/material.dart';
import '../../models/structures/constants.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: buttonBackgroundColor,
          border: Border.all(
            width: 2.0,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 3, bottom: 3),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 3),
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 18,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Search",
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(fontSize: 15, color: Colors.grey,fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
