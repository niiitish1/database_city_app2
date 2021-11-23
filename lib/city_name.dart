import 'package:database_state_city/common.dart';
import 'package:database_state_city/main.dart';
import 'package:flutter/material.dart';

class MyCity extends StatefulWidget {
  MyCity(this.arr, this.cityData, {Key? key}) : super(key: key);

  List arr;
  Map<String, dynamic> cityData;

  @override
  _MyCityState createState() => _MyCityState(arr, cityData);
}

class _MyCityState extends State<MyCity> {
  var newArr = [];
  List arr;
  Map<String, dynamic> cityData;
  _MyCityState(this.arr, this.cityData);

  @override
  void initState() {
    super.initState();
    // HomePage homePage = HomePage();

    newArr = cityData[arr[Common.index]];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("City Name"),
      ),
      body: SafeArea(
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: newArr.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(newArr[index]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
