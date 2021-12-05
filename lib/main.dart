import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
    title: 'Home',
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> cityDict = HashMap();
  var stateArr = [];
  var cityArr = [];
  final cityController = TextEditingController();
  @override
  void initState() {
    super.initState();
    checkLocalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: ListView.separated(
          itemBuilder: (context, stateIndex) {
            cityArr = cityDict[stateArr[stateIndex]];
            return ExpansionTile(
              title: Text(stateArr[stateIndex],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600)),
              children: [
                Column(
                  children: List.generate(cityArr.length, (cityIndex) {
                    return buildCityUI(cityIndex, stateIndex);
                  }),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        addCityDialogBox(stateIndex);
                      },
                      child: const Text('Add City')),
                )
              ],
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: stateArr.length,
        ),

        // child: ListView.separated(
        //   separatorBuilder: (context, index) {
        //     return const Divider(
        //       color: Colors.green,
        //     );
        //   },
        //   itemCount: stateArr.length,
        //   itemBuilder: (context, stateIndex) {
        //     return GestureDetector(
        //       child: Container(
        //         padding: const EdgeInsets.all(15.0),
        //         child: Column(
        //           children: [
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Text(stateArr[stateIndex]),
        //                 checkOpenClose[stateIndex] == true
        //                     ? const Icon(
        //                         Icons.arrow_upward,
        //                         color: Colors.black,
        //                       )
        //                     : const Icon(
        //                         Icons.arrow_downward,
        //                         color: Colors.black,
        //                       )
        //               ],
        //             ),
        //             checkOpenClose[stateIndex] == true
        //                 ? Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       for (var item in cityArr) ...{Text(item)},
        //                     ],
        //                   )
        //                 : const SizedBox()
        //           ],
        //         ),
        //       ),
        //       onTap: () {
        //         setState(() {
        //           cityArr = cityDict[stateArr[stateIndex]];
        //           checkOpenClose.containsKey(stateIndex)
        //               ? checkOpenClose[stateIndex] == true
        //                   ? checkOpenClose[stateIndex] = false
        //                   : checkOpenClose[stateIndex] = true
        //               : checkOpenClose[stateIndex] = true;
        //           print("done");
        //         });
        //       },
        //     );
        //     // return GestureDetector(
        //     //   onTap: () {
        //     //     Common.index = index;
        //     //     Navigator.push(
        //     //       context,
        //     //       MaterialPageRoute(
        //     //         builder: (context) => MyCity(arr, cityDict),
        //     //       ),
        //     //     );
        //     //   },
        //     //   child: Padding(
        //     //     padding: const EdgeInsets.all(12.0),
        //     //     child: Column(
        //     //       crossAxisAlignment: CrossAxisAlignment.start,
        //     //       children: [
        //     //         Text(arr[index]),
        //     //       ],
        //     //     ),
        //     //   ),
        //     // );
        //   },
        // ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("State Name"),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert_outlined),
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                apiCall();
              },
              child: const Text('Reload Data'),
            )
          ],
        )
      ],
    );
  }

  apiCall() async {
    print('api call');
    http.post(
      Uri.parse("https://www.kalyanmobile.com/apiv1_staging/city_listing.php"),
      body: {
        "request": "city_listing",
        "device_type": "android",
        "country": "india",
      },
    ).then((resp) {
      var jsonResp = jsonDecode(resp.body);
      cityDict = jsonResp['city_array'];
      // jsonencode:- convert object to String...
      SharedPreferences.getInstance().then((pref) {
        pref.setString('data', jsonEncode(cityDict));
        checkLocalData();
      });
    });
  }

  checkLocalData() async {
    SharedPreferences.getInstance().then((pref) {
      var data = pref.getString('data');
      if (data == null) {
        apiCall();
      } else {
        //jsonDecode:- convert String to object......
        cityDict = jsonDecode(data);
        setState(() {
          stateArr = cityDict.keys.toList();
        });
      }
    });
  }

  Widget buildCityUI(int cityIndex, int stateIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              updateCityName(stateIndex, cityIndex);
              var tempArr = [];
              tempArr = cityDict[stateArr[stateIndex]];
              tempArr[cityIndex] = 'hello nitish12';
            },
            child: Text(
              cityArr[cityIndex],
              style: const TextStyle(fontSize: 18),
            ),
          ),
          GestureDetector(
            child: const Icon(Icons.delete),
            onTap: () {
              deleteCity(cityIndex, stateIndex);
            },
          ),
        ],
      ),
    );
  }

  deleteCity(int cityIndex, int stateIndex) {
    var tempArr = [];
    tempArr = cityDict[stateArr[stateIndex]];
    tempArr.removeAt(cityIndex);
    setState(() {
      cityDict[stateArr[stateIndex]] = tempArr;
    });
    storeData();
  }

  storeData() {
    SharedPreferences.getInstance()
        .then((pref) => pref.setString('data', jsonEncode(cityDict)));
  }

  addCityDialogBox(int stateIndex) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Add Your City Name in ${stateArr[stateIndex]}'),
          titleTextStyle: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          titlePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter City Name',
                  hintText: 'City Name',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      var tempArr = [];
                      tempArr = cityDict[stateArr[stateIndex]];
                      tempArr.add(cityController.text);
                      setState(() {
                        cityDict[stateArr[stateIndex]] = tempArr;
                      });
                      storeData();
                      Navigator.pop(context, 'Lost');
                      cityController.clear();
                    },
                    child: const Text('Add City')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, 'Lost');
                    },
                    child: const Text('Cancel')),
              ],
            ),
          ],
        );
      },
    );
  }

  dummyMethod() {
    Map<String, dynamic> cityHashMap = HashMap();
    var array = [];
    cityHashMap['Mumbai'] = ['Bhayander', 'Mira-road', 'Dahisar'];
    cityHashMap['Up'] = ['Mau', 'Gorakhpur', 'Gazzia'];
    cityHashMap['Bihar'] = ['city1', 'city2'];
    print('before remove:======== $cityHashMap');
    array = cityHashMap['Mumbai'];
    array.removeAt(0);
    cityHashMap["Mumbai"] = array;
    print('after remove:========= $cityHashMap');
  }

  updateCityName(int stateIndex, int cityIndex) {
    var tempArr = [];
    tempArr = cityDict[stateArr[stateIndex]];
    String cityName = tempArr.elementAt(cityIndex);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Update Your City Name $cityName'),
          titleTextStyle: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          titlePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: TextField(
                controller: cityController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Update City Name',
                    hintText: 'update $cityName to '),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      tempArr[cityIndex] = cityController.text;
                      setState(() {
                        cityDict[stateArr[stateIndex]] = tempArr;
                      });
                      storeData();
                      Navigator.pop(context, 'Lost');
                      cityController.clear();
                    },
                    child: const Text('Update City')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, 'Lost');
                    },
                    child: const Text('Cancel')),
              ],
            ),
          ],
        );
      },
    );
  }
}
