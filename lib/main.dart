import 'dart:async';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart';

import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Medical Information Request Form'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ConnectivityResult result;
  final dbHelper = DatabaseHelper.instance;
  List response = ["Fax", "Mail", "Email", "Phone"];
  List gender = ["Male", "Female", "Others"];
  List designation = ["MD", "DO", "NP", "PA"];
  List products = ["10 MG - Roszet", "20 MG - Roszet"];
  List checkOne = [
    "This inquiry does not represent an adverse event experienced by a patient",
    "This inquiry represent an adverse event experienced by a patient"
  ];
  String dropdownValue = 'Alabama';
  String select;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;



  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child: SingleChildScrollView(
          child: Form(
              child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                    padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Medical Information Request Form",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "A. Healthcare Professional Contact Information",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Requestor's First Name*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Requestor's Last Name*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Designation*',
                          ),
                          Column(
                            children: <Widget>[
                              addRadioButton(0, 'MD'),
                              addRadioButton(1, 'DO'),
                              addRadioButton(2, 'NP'),
                              addRadioButton(3, 'PA'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Institution/Office*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Department*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Institution/Office Address Line*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Institution/Office Address Line 2",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("State*"),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.deepPurple),
                          underline:SizedBox(),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>[
                            'Alabama',
                            'Texas',
                            'Indiana',
                            'Hyderabad'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "City*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Zip",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                 
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Phone Number",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Fax Number",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "B. Unsolicited Information Request:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Choose Products*:',
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                addProductRadioButton(0, '10 MG - Roszet'),
                                addProductRadioButton(1, '20 MG - Roszet'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: "Request Description:",
                           border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 5)
                            ),
                            onSaved: (String value) {},
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Please Check One:',
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                addCheckRadioButton(0,
                                    'This inquiry does not represent an adverse event experienced by a patient'),
                                addCheckRadioButton(1,
                                    'This inquiry represent an adverse event experienced by a patient'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            decoration: const InputDecoration(
                              hintText: "Patient Name*",
                           border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 5)
                            ),
                            onSaved: (String value) {},
                          ),
                        ),
                      ),
                      Card(
                        child: DateTimeField(
                            // format: format,
                            // format: DateFormat('dd-MM-yyyy'),
                            initialValue: DateTime.now(),
                            validator: (selectedYear) =>
                                selectedYear != null ? null : 'Select Date',
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Date of Birth",
                              contentPadding: EdgeInsets.all(15),
                            ),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                            },
                            onSaved: (val) => setState(() {})),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Gender*',
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                addGenderRadioButton(0, 'Male'),
                                addGenderRadioButton(1, 'Female'),
                                addGenderRadioButton(1, 'Others'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: DateTimeField(
                            // format: format,
                            // format: DateFormat('dd-MM-yyyy'),
                            initialValue: DateTime.now(),
                            validator: (selectedYear) =>
                                selectedYear != null ? null : 'Select Date',
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Date of Request",
                              contentPadding: EdgeInsets.all(15),
                            ),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                            },
                            onSaved: (val) => setState(() {})),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Preferred Method of Response*',
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                addResponseRadioButton(0, 'Fax'),
                                addResponseRadioButton(1, 'Mail'),
                                addResponseRadioButton(2, 'Email'),
                                addResponseRadioButton(3, 'Phone'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("Health Care professional's Signature:*"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Signature(
                                controller: _controller,
                                height: 200,
                                backgroundColor: Colors.white,
                              ),
                              RaisedButton(
                                child: Icon(Icons.refresh),
                                onPressed: () {
                                  _controller.clear();
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "C. Representative Contact Information: (To Be Completed By Representative)",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "By Submitting this form, I certify that is request for information was initiated by Health Care Professional stated above, and was not solicited by me in any manner",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Representative Name*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Representative Type*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                 
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Representative Territory Number*",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Country Code",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: const InputDecoration(
                              hintText: "Primary TelePhone Number",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5)),
                          onSaved: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: RaisedButton(
                    child: Text("Submit"),
                    onPressed: (){

                      switch (result) {
                        case ConnectivityResult.wifi:
                        case ConnectivityResult.mobile:
                           //api call for submitting form data object
                             print(result);
                          break;
                        default:
                          _insert();
                          print("offline app");
                          break;
                      }

                    },
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }

  Row addGenderRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: designation[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  Row addResponseRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: response[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  Row addProductRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: products[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  Row addCheckRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: checkOne[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Flexible(child: Text(title))
      ],
    );
  }

//       **********Offline Handling of form data in sqlite db***********
  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.requestorName : 'Bob',
      DatabaseHelper.requestorPhonenumber  : 9915121632
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }
}
