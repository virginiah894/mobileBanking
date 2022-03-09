
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String sourceaccount;
  final String utilityprovider;
  final String billnumber;
  final String amount;
  final String narration;



  MyAlertDialog(this.title, this.sourceaccount, this.utilityprovider,
      this.billnumber, this.amount, this.narration);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              this.sourceaccount,
              style: Theme.of(context).textTheme.bodyText1),
            Text(
                this.utilityprovider,
                style: Theme.of(context).textTheme.bodyText1),
            Text(
                this.billnumber,
                style: Theme.of(context).textTheme.bodyText1),
            Text(
                this.amount,
                style: Theme.of(context).textTheme.bodyText1),
            Text(
                this.narration,
                style: Theme.of(context).textTheme.bodyText1)
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CONFIRM'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],

    );
  }
}

