import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:database_state_city/city_name.dart';
import 'package:database_state_city/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var stateArr = [];
  var cityArr = [];
  var isOpen = false;
  Map<String, dynamic> cityDict = HashMap();
  Map<int, bool> checkOpenClose = HashMap();
  @override
  void initState() {
    super.initState();
    apiDemo();
  }

  @override
  Widget build(BuildContext context) {
    // isOpen = false;
    return Scaffold(
      appBar: AppBar(
        title: Text("State Name"),
      ),
      body: SafeArea(
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.green,
            );
          },
          itemCount: stateArr.length,
          itemBuilder: (context, stateIndex) {
            return GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(stateArr[stateIndex]),
                        checkOpenClose[stateIndex] == true
                            ? const Icon(
                                Icons.arrow_upward,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.arrow_downward,
                                color: Colors.black,
                              )
                      ],
                    ),
                    checkOpenClose[stateIndex] == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var item in cityArr) ...{Text(item)},
                            ],
                          )
                        : const SizedBox()
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  cityArr = cityDict[stateArr[stateIndex]];
                  checkOpenClose.containsKey(stateIndex)
                      ? checkOpenClose[stateIndex] == true
                          ? checkOpenClose[stateIndex] = false
                          : checkOpenClose[stateIndex] = true
                      : checkOpenClose[stateIndex] = true;
                  print("done");
                });
              },
            );

            // return GestureDetector(
            //   onTap: () {
            //     Common.index = index;
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => MyCity(arr, cityDict),
            //       ),
            //     );
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(12.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(arr[index]),
            //       ],
            //     ),
            //   ),
            // );
          },
        ),
      ),
    );
  }

  apiDemo() async {
    var resp = await http.post(
      Uri.parse("https://www.kalyanmobile.com/apiv1_staging/city_listing.php"),
      body: {
        "request": "city_listing",
        "device_type": "android",
        "country": "india",
      },
    );
    var jsonResp = jsonDecode(resp.body);

    cityDict = jsonResp["city_array"];
    setState(() {
      stateArr = cityDict.keys.toList();
    });
  }
}
