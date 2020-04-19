import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import 'models/transaction.dart';

void main() {
  // Restricted app to portrait mode.
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('print() MyApp()');
    return MaterialApp(
      title: 'Expense Planner',
      //App Theme
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        //AppBar Theme
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        // Text Title theme
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //String inputTitle;
  //String inputAmount;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = false;

  final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: 't1',
    //   title: 'Shoes',
    //   amount: 29.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't1',
    //   title: 'Watch',
    //   amount: 29.99,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tnx) {
      return tnx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    // Add observer when state change.
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  // Override method of "WidgetsBindingObserver"
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // To clear listener when widget or state not require. and to avoid memory lick
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _addNewTransaction(
      String txtTitle, double txtAmount, DateTime chosenDate) {
    final newTrans = Transaction(
      id: DateTime.now().toString(),
      title: txtTitle,
      amount: txtAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransaction.add(newTrans);
    });
  }

  void _startAddTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCTX) {
          return GestureDetector(
            child: NewTransaction(_addNewTransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      // _userTransaction.removeWhere((ctx) {
      //   return ctx.id == id;
      // });

      //Shortan
      _userTransaction.removeWhere((ctx) => ctx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txnListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.title,
          ),

          // Switch.adaptive auto adapt different platform.
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.8,
              child: Chart(_recentTransaction),
            )
          : txnListWidget,
    ];
  }

  List<Widget> _buildPorttraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txnListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransaction),
      ),
      txnListWidget,
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expense Planner'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, // Set Row width to min
              children: <Widget>[
                GestureDetector(
                  // ALSO YOU CAN USE CupertinoIconButton
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Expense Planner'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () => _startAddTransaction(context),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    //DECLARE MEDIAQUARY VARIABLE SO DO NOT CREATE VARIABLE EVERY TIME WHEN WE USE.
    final mediaQuery = MediaQuery.of(context);
    // TO GET ORIENTATION.
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    // Change retuen type to PreferredSizeWidget
    final PreferredSizeWidget appBar = _buildAppBar();

    final txnListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransaction, _deleteTransaction),
    );

    // In iOS notch device some of the space is reserve for notch and bottom taskbar device - iOS10
    // SafeArea widget is used to get that area and remove that mush space that notch cover
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1.  NEW IF IN DART
            // 2.  ( ... ) is a spred operator is use to pull out all element from the list
            //     and merge them in single element surrounding using list that is "children: <Widget>["
            //     in short - convert list into the single item.
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txnListWidget),
            if (!isLandscape)
              ..._buildPorttraitContent(mediaQuery, appBar, txnListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddTransaction(context),
                  ),
          );
  }
}
