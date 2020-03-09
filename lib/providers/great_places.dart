import 'dart:io';
import 'package:flutter/foundation.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

 Future<void> addPlace(String pickedTitle, File pickedImage) async {
  //Future<void> addPlace(String pickedTitle, File pickedImage, PlaceLocation pickedLocation) async {
    //final address = await LocationHelper.getPlaceAdress(pickedLocation.latitude, pickedLocation.longitude);
    // final updatedLocation = PlaceLocation(
    //   latitude: pickedLocation.latitude, 
    //   longitude: pickedLocation.longitude, 
    //   address: address,
    // );
    final newplace  = Place(
      id: DateTime.now().toString(), 
      image: pickedImage,
      title: pickedTitle, 
      location: null,
      //location: updatedLocation, 
    );
    _items.add(newplace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newplace.id, 
      'title': newplace.title, 
      'image': newplace.image.path,
      // 'loc_lat': newplace.location.latitude,
      // 'loc_lng': newplace.location.longitude,
      // 'address': newplace.location.address 
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList.map((item) => Place(
      id: item['id'], 
      title: item['title'], 
      image: File(item['image']),
      location: null
      // location: PlaceLocation(
      //   latitude: item['loc_lat'], 
      //   longitude: item['loc_lng'], 
      //   address: item['address'],
      // ),
     ),
    ).toList();
    notifyListeners();
  }
}