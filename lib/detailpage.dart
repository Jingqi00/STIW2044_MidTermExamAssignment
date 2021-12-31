import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rentaroom/room.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({ Key? key, required this.room}) : super(key: key);
  final Room room;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List detailList = [];
  int scrollcount = 10;
  int numroom = 0, rowcount = 2;
  String loading = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  final List<int> numbers = [1,2,3];

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  @override
  Widget build(BuildContext context) {
   screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Details'),
        backgroundColor: Colors.amber,
      ),
    body: Stack(
      children:[
        upperHalf(context), lowerHalf(context)
      ]
    ),
    );
  }

  Widget upperHalf(BuildContext context){
    return Scaffold(
    body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
            itemCount: numbers.length, itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Card(
                  color: Colors.amberAccent,
                  child: Padding(
                  padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                  child: CachedNetworkImage(  
                      width: screenWidth,
                      fit: BoxFit.cover,
                      imageUrl: "https://slumberjer.com/rentaroom/images/" + widget.room.roomid.toString() + "_" + numbers[index].toString() + ".jpg",
                      progressIndicatorBuilder: (context, url, downloadProgress) => 
                      CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                  ),      
                ),
              ),
            );
          }
        ),      
      ),      
    );
  }   

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 600,
      margin: EdgeInsets.only(top: screenHeight / 3),
      padding: const EdgeInsets.only(left:10, right:10),
      child: SingleChildScrollView(
        child: Column(
          children: [
          Text("ROOM ID: " + widget.room.roomid.toString(),style:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Table(
                  columnWidths: const {
                    0: FractionColumnWidth(0.4),
                    1: FractionColumnWidth(0.6)
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: [
                    TableRow(children: [
                      const Text('TITLE',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.title.toString()),
                    ]),
                    TableRow(children: [
                      const Text('DESCRIPTION',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.description.toString()),
                    ]),
                    TableRow(children: [
                      const Text('CONTACT',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.contact.toString()),
                    ]),
                    TableRow(children: [
                      const Text('PRICE',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("RM " + widget.room.price.toString()),
                    ]),
                    TableRow(children: [
                      const Text('DEPOSIT',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("RM " + widget.room.deposit.toString()),
                    ]),
                    TableRow(children: [
                      const Text('STATE',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.state.toString()),
                    ]),
                    TableRow(children: [
                      const Text('AREA',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.area.toString()),
                    ]),
                    TableRow(children: [
                      const Text('DATE_CREATED',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.date_created.toString()),
                    ]),
                    TableRow(children: [
                      const Text('LATITUDE',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.latitude.toString()),
                    ]),
                    TableRow(children: [
                      const Text('LONGITUDE',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.room.longitude.toString()),
                    ]),                   
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
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
}

