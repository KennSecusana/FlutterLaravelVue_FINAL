// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/api/create.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Createddata obj = Createddata();
  TextEditingController point_of_originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController passenger_nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController contact_noController = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieve();
    delete(id);
    update(id);
    obj.datacreated(point_of_originController.text, destinationController.text,
   passenger_nameController.text, ageController.text, contact_noController.text);
  }

  List data = [];
  String? id;
  Future retrieve() async {
    final response =
    await http.get(Uri.parse('http://192.168.1.4:8000/api/bookings'));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
      print('Add data$data');
    } else {
      print('Error');
    }
  }

  Future delete(id) async {
    final response = await http
        .delete(Uri.parse('http://192.168.1.4:8000/api/bookings/$id'));
    print('outside');
    print(response.statusCode);

    final responseShow = await http
        .get(Uri.parse('http://192.168.1.4:8000/api/bookings/$id'));
    print(responseShow.body);

    if (response.statusCode == 200) {
      print('Data deleted successfully');
      print(responseShow.body);
    } else {
      print('Error deleting data');
    }
  }

  Future update(id) async {
    final response = await http
        .put(Uri.parse('http://192.168.1.4:8000/api/bookings/$id'),
        body: jsonEncode({
          "point_of_origin": point_of_originController.text,
          "destination": destinationController.text,
          "passenger_name": passenger_nameController.text,
          "age": ageController.text,
          "contact_no": contact_noController.text,

        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    print(response.statusCode);

    final responseShow = await http
        .get(Uri.parse('http://192.168.1.4:8000/api/bookings/$id'));
    print(responseShow.body);

    if (response.statusCode == 200) {
      print('Data updated successfully');
      point_of_originController.clear();
      destinationController.clear();
      passenger_nameController.clear();
      ageController.clear();
      contact_noController.clear();
    } else {
      print('Error updating data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },

      child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Online Bus System', style: TextStyle(color: Colors.white),),
        centerTitle: true,

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            obj.datacreated(
                              point_of_originController.text,
                              destinationController.text,
                              passenger_nameController.text,
                              ageController.text,
                              contact_noController.text,

                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary:Colors.green.shade700
                        ),
                        child: Text('Create', style: TextStyle(color: Colors.white))),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            update(1);
                          },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary:Colors.orange

                        ),
                        child: Text('Update', style: TextStyle(color: Colors.white))),

                    ElevatedButton(
                      child: Text('Operators', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                              SecondRoute()),

                          );
                        },
                    )
                  ],
                ),

                Card(elevation: 3,
                 margin: EdgeInsets.only(top: 1.0),
                  child: Column(
                    children: <Widget>[


                      TextField(
                        controller: point_of_originController,
                        decoration: InputDecoration(
                          hintText: 'Point of Origin',
                        ),
                      ),


                      TextField(
                        controller: destinationController,
                        decoration: InputDecoration(
                          hintText: 'Destination',
                        ),
                      ),

                      TextField(
                        controller: passenger_nameController,
                        decoration: InputDecoration(
                          hintText: 'Passenger Name',
                        ),
                      ),

                      TextField(
                        controller: ageController,
                        decoration: InputDecoration(
                          hintText: 'Age',
                        ),
                      ),

                      TextField(
                        controller: contact_noController,
                        decoration: InputDecoration(
                          hintText: 'Contact No',
                        ),
                      ),


                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {


                     return Card(
                       color: Colors.cyan,
                       margin: EdgeInsets.only(top:20.0),
                        elevation:4,



                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                                 Row(
                                  children: [
                                    Text('Point of Origin:', style: TextStyle(color: Colors.white, fontSize: 15),),
                                    Padding(
                                        padding: EdgeInsets.only(left: 30.0),
                                        child: Text(data[index]['point_of_origin'], style: TextStyle(color: Colors.white, fontSize: 17.5),),

                                  ),
                                    Text("\n"),
                                  ],
                                ),

                                Row(
                                   children: [
                                     Text('Destination:', style: TextStyle(color: Colors.white, fontSize: 15),),
                                     Padding(
                                       padding: EdgeInsets.only(left: 49.0),
                                       child: Text(data[index]['destination'], style: TextStyle(color: Colors.white, fontSize: 17.5),),

                                     ),
                                     Text("\n")
                                   ],
                               ),

                            Row(
                              children: [
                                Text('Passenger Name:', style: TextStyle(color: Colors.white, fontSize: 15),),
                                Padding(
                                  padding: EdgeInsets.only(left: 13.0),
                                  child: Text(data[index]['passenger_name'], style: TextStyle(color: Colors.white, fontSize: 17.5),),

                                ),
                                Text("\n")
                              ],
                            ), Row(
                              children: [
                                Text('Age:', style: TextStyle(color: Colors.white, fontSize: 15),),
                                Padding(
                                  padding: EdgeInsets.only(left: 103.0),
                                  child: Text(data[index]['age'], style: TextStyle(color: Colors.white, fontSize: 17.5),),

                                ),
                                Text("\n")
                              ],
                            ), Row(
                              children: [
                                Text('Contact No:', style: TextStyle(color: Colors.white, fontSize: 15),),
                                Padding(
                                  padding: EdgeInsets.only(left: 55.0),
                                  child: Text(data[index]['contact_no'], style: TextStyle(color: Colors.white, fontSize: 17.5),),

                                ),
                                Text("\n")
                              ],
                            ),

                         Container(
                              width: 100,

                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        point_of_originController.text =
                                        data[index]['point_of_origin'];
                                        destinationController.text =
                                        data[index]['destination'];
                                        passenger_nameController.text =
                                        data[index]['passenger_name'];
                                        ageController.text =
                                        data[index]['age'];
                                        contact_noController.text =
                                        data[index]['contact_no'];

                                      },
                                      icon: Icon(Icons.edit,), color: Colors.orange,),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          delete(data[index]['id']);
                                        });
                                      },
                                      icon: Icon(Icons.delete), color: Colors.red,),
                                ],
                              ),
                            ),
                          ]
                        )
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
      )
    );
  }
}







class SecondRoute extends StatefulWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  var obj = CreateOperator();
  TextEditingController operator_nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contact_noController = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieve();
    delete(id);
    update(id);
    obj.operatorCreated(operator_nameController.text, addressController.text,
        contact_noController.text);
  }

  List data = [];
  String? id;
  Future retrieve() async {
    final response =
    await http.get(Uri.parse('http://192.168.1.4:8000/api/operators'));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
      print('Add data$data');
    } else {
      print('Error');
    }
  }

  Future delete(id) async {
    final response = await http
        .delete(Uri.parse('http://192.168.1.4:8000/api/operators/$id'));
    print('outside');
    print(response.statusCode);

    final responseShow = await http
        .get(Uri.parse('http://192.168.1.4:8000/api/operators/$id'));
    print(responseShow.body);

    if (response.statusCode == 200) {
      print('Data deleted successfully');
      print(responseShow.body);
    } else {
      print('Error deleting data');
    }
  }

  Future update(id) async {
    final response = await http
        .put(Uri.parse('http://192.168.1.4:8000/api/operators/$id'),
        body: jsonEncode({
          "operator_name": operator_nameController.text,
          "address": addressController.text,
          "contact_no": contact_noController.text,
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    print(response.statusCode);

    final responseShow = await http
        .get(Uri.parse('http://192.168.1.4:8000/api/operators/$id'));
    print(responseShow.body);

    if (response.statusCode == 200) {
      print('Data updated successfully');
      operator_nameController.clear();
      addressController.clear();
      contact_noController.clear();
    } else {
      print('Error updating data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },

        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.cyan,
            title: Text('Online Bus System', style: TextStyle(color: Colors.white),),
            centerTitle: true,

          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                obj.operatorCreated(
                                  operator_nameController.text,
                                  addressController.text,
                                  contact_noController.text,

                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary:Colors.green.shade700
                            ),
                            child: Text('Create', style: TextStyle(color: Colors.white))),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                update(1);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary:Colors.orange
                            ),
                            child: Text('Update', style: TextStyle(color: Colors.white))),

                        ElevatedButton(
                          child: Text('Bookings', style: TextStyle(color: Colors.white)),
                          onPressed: () {
                             Navigator.pop(context);
                               },
                        )
                      ],
                    ),

                    Card(elevation: 3,
                      margin: EdgeInsets.only(top: 1.0),
                      child: Column(
                        children: <Widget>[


                          TextField(
                            controller: operator_nameController,
                            decoration: InputDecoration(
                              hintText: 'Operator Name',
                            ),
                          ),


                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              hintText: 'Address',
                            ),
                          ),

                          TextField(
                            controller: contact_noController,
                            decoration: InputDecoration(
                              hintText: 'Contact No',
                            ),
                          ),

                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {


                            return Card(
                                color: Colors.cyan,
                                margin: EdgeInsets.only(top:20.0),
                                elevation:4,



                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Text('Operator Name:', style: TextStyle(color: Colors.white, fontSize: 15),),
                                          Padding(
                                            padding: EdgeInsets.only(left: 30.0),
                                            child: Text(data[index]['operator_name'], style: TextStyle(color: Colors.white, fontSize: 17.5),),

                                          ),
                                          Text("\n"),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Text('Address:', style: TextStyle(color: Colors.white, fontSize: 15),),
                                          Padding(
                                            padding: EdgeInsets.only(left: 78.0),
                                            child: Text(data[index]['address'], style: TextStyle(color: Colors.white, fontSize: 17.5),),

                                          ),
                                          Text("\n")
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Text('Contact No:', style: TextStyle(color: Colors.white, fontSize: 15),),
                                          Padding(
                                            padding: EdgeInsets.only(left: 56.0),
                                            child: Text(data[index]['contact_no'], style: TextStyle(color: Colors.white, fontSize: 17.5),),

                                          ),
                                          Text("\n")
                                        ],
                                      ),
                                      Container(
                                        width: 100,

                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                operator_nameController.text =
                                                data[index]['operator_name'];
                                                addressController.text =
                                                data[index]['address'];
                                                contact_noController.text =
                                                data[index]['contact_no'];


                                              },
                                              icon: Icon(Icons.edit,), color: Colors.orange,),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  delete(data[index]['id']);
                                                });
                                              },
                                              icon: Icon(Icons.delete), color: Colors.red,),
                                          ],
                                        ),
                                      ),
                                    ]
                                )
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}

class CreateOperator {

  Future operatorCreated(operator_nametext, addresstext, contact_notext) async {
    final response =
    await http.post(Uri.parse('http://192.168.1.4:8000/api/operators'),
        body: jsonEncode({
          "operator_name":operator_nametext,
          "address": addresstext,
          "contact_no": contact_notext,
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',

        });
    print(response.statusCode);
    if (response.statusCode == 200) {

      print('Data Created Successfully');
      print(response.body);
    } else {
      print('Error creating data');
    }
  }

}

