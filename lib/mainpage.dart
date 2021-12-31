import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rentaroom/detailpage.dart';
import 'package:rentaroom/room.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({ Key? key }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List detailList = [];
  String loading = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  late ScrollController _scrollController;
  int scrollcount = 10;
  int rowcount = 2;
  int numroom = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }

    return Scaffold(
        body: detailList.isEmpty
            ? Center(
                child: Text(loading,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)))
            : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Text("Rent Room Available",
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold)),
                  ),
                  Text(numroom.toString() + " room is found", style: const TextStyle(fontStyle: FontStyle.italic)),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: rowcount,
                      controller: _scrollController,
                      children: List.generate(scrollcount, (index) {
                        return Card(
                            child: InkWell(
                          onTap: () => {_roomDetails(index)},
                          child: Column(
                            children: [
                              Flexible(
                                flex: 5,
                                child: CachedNetworkImage(  
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl: "https://slumberjer.com/rentaroom/images/" + detailList[index]['roomid'] + "_1.jpg",
                                    progressIndicatorBuilder: (context, url, downloadProgress) => 
                                    CircularProgressIndicator(value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                ), 
                              ),
                              
                              Flexible(
                                  flex: 5,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                            truncateString(detailList[index]['title'].toString()),
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold)
                                                ),
                                          const SizedBox(height:10),
                                          Text(
                                            "Price[Monthly]: RM " + 
                                            truncateString(detailList[index]['price'].toString()),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),   
                                          Text(
                                            "Deposit: RM " + 
                                            truncateString(detailList[index]['deposit'].toString()),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                          Text(
                                            "Area: " + 
                                            truncateString(detailList[index]['area'].toString()),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)), 
                                      ],
                                    ),
                                  )
                                ),
                            ],
                          ),
                        ));
                      }),
                    ),
                  ),
                ],
              ),
    );
  }

  Future<void> _loadDetails() async {
    var url = Uri.parse('https://slumberjer.com/rentaroom/php/load_rooms.php');
      var response = await http.get(url);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        print(response.body);
        var extractdata = data['data'];
        setState(() {
        detailList = extractdata["rooms"];
        numroom = detailList.length;
          if (scrollcount >= detailList.length) {
            scrollcount = detailList.length;
          }
        });
      } else {
        setState(() {
          loading = "No Data";
        });
      }
    }  

  String truncateString(String str) {
    if (str.length > 15) {
      str = str.substring(0, 15);
      return str + "...";
    } else {
      return str;
    }
  }

  _roomDetails(int index) {
    late Room room = Room(
        roomid: detailList[index]['roomid'],
        contact: detailList[index]['contact'],
        title: detailList[index]['title'],
        description: detailList[index]['description'],
        price: detailList[index]['price'],
        deposit: detailList[index]['deposit'],
        state: detailList[index]['state'],
        area: detailList[index]['area'],
        date_created: detailList[index]['date_created'],
        latitude: detailList[index]['latitude'],
        longitude: detailList[index]['longitude']
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: const Text(
              "View Detail?",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(resWidth * 0.02, resWidth * 0.02),primary: Colors.amber),
                  child: const Text('Yes',style: TextStyle(fontSize:18)),
                  onPressed: () => {
                    Navigator.pop(context),
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(room:room)))
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(resWidth * 0.02 , resWidth * 0.02),primary: Colors.teal),
                  child: const Text('No',style: TextStyle(fontSize:18)),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    const MainPage(),
                  },
                ),
              ],
          )
        );
      },
    );          
  } 
  
  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (detailList.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= detailList.length) {
            scrollcount = detailList.length;
          }
        }
      });
    }
  }     
}
