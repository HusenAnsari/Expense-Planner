import 'dart:math';

import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required Function deleteTrans,
  }) : _deleteTrans = deleteTrans, super(key: key);

  final Transaction transaction;
  final Function _deleteTrans;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;

  // No need to user setState() when using initState() becauser
  // initState() is called before build() execute / ru.
  @override
  void initState() {
    const availabileColor = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.purple,
    ];

    _bgColor = availabileColor[Random().nextInt(4)];
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 10,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
                child: Text('\$${widget.transaction.amount}')),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        // GET DEVICE WIDTH
        trailing: MediaQuery.of(context).size.width > 360
            ? FlatButton.icon(
                onPressed: () => widget._deleteTrans(widget.transaction.id),
                icon: Icon(Icons.delete),
                label: Text(
                  'Delete',
                  //style: Theme.of(context).textTheme.title,
                ),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget._deleteTrans(widget.transaction.id),
              ),
      ),
    );
  }
}

