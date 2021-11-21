import 'dart:convert';

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
  var itemClicked = -1;
  var cityArr = [];
  var isOpen = true;
  Map<String, dynamic> cityDict = Map();
  @override
  void initState() {
    super.initState();
    apiDemo();
  }

  @override
  Widget build(BuildContext context) {
    // isOpen ? isOpen = false : isOpen = true;

    return Scaffold(
      appBar: AppBar(
        title: Text("State Name"),
      ),
      body: SafeArea(
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: stateArr.length,
          itemBuilder: (context, stateIndex) {
            return GestureDetector(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(stateArr[stateIndex]),
                      itemClicked == stateIndex && isOpen
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
                  itemClicked == stateIndex && isOpen
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var item in cityArr) ...{Text(item)},
                          ],
                        )
                      : SizedBox()
                ],
              ),
              onTap: () {
                setState(() {
                  itemClicked = stateIndex;
                  cityArr = cityDict[stateArr[stateIndex]];
                  isOpen ? isOpen = false : isOpen = true;
                  print("$stateIndex is clicked..................");
                  // for (var item in cityArr) {
                  //   print(item);
                  // }
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
    stateArr = cityDict.keys.toList();
    setState(() {});

    // for (var item in stateArr) {
    //   print("Item is --> $item");
    //   print("$item Cities --->${cityDict[item]}");
    // }
  }
}
