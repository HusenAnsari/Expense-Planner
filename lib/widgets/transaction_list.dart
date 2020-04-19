import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './transaction_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function _deleteTrans;

  const TransactionList(this.transaction, this._deleteTrans);

  @override
  Widget build(BuildContext context) {
    print('print() TransactionList()');
    if (transaction.isEmpty) {
      return LayoutBuilder(
        builder: (ctx, constraints) => Column(
          children: <Widget>[
            Text(
              'No transaction added yet!',
              style: Theme.of(context).textTheme.title,
            ),
            //Use for Empty box
            SizedBox(
              height: 20,
            ),
            Container(
              height: constraints.maxHeight * 0.7,
              child: Image.asset(
                'assets/images/waiting.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      );
    } else {
      return ListView(
        children: transaction
            .map((txn) => TransactionItem(
                  key: ValueKey(txn.id),
                  transaction: txn,
                  deleteTrans: _deleteTrans,
                ))
            .toList(),
      );
    }

    // : ListView.builder(
    // itemBuilder: (ctx, index) {
    //   return TransactionItem(transaction: transaction[index], deleteTrans: _deleteTrans);
    // },
    // itemCount: transaction.length);
  }
}
