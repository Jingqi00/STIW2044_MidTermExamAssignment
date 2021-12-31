class Room {
  String? roomid;
  String? contact;
  String? title;
  String? description;
  String? price;
  String? deposit;
  String? state;
  String? area;
  String? date_created;
  String? latitude;
  String? longitude;

  Room(
      {required this.roomid,
      required this.contact,
      required this.title,
      required this.description,
      required this.price,
      required this.deposit,
      required this.state,
      required this.area,
      required this.date_created,
      required this.latitude,
      required this.longitude,});

  Room.fromJson(Map<String, dynamic> json) {
    roomid = json['roomid'];
    contact = json['contact'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    deposit = json['deposit'];
    state = json['state'];
    area = json['area'];
    date_created = json['date_created'];
    latitude = json['latitude'];
    longitude = json['longitude'];   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomid'] = roomid;
    data['contact'] = contact;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['deposit'] = deposit;
    data['state'] = state;
    data['area'] = area;
    data['date_created'] = date_created;
    data['latitude'] = latitude;
    data['longitude'] = longitude;    
    return data;
  }
}