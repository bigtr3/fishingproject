import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'stopwatch.dart';

class FishingService extends ChangeNotifier {
  final fishingCollection = FirebaseFirestore.instance.collection('fishing');
  Future<QuerySnapshot> read(String email) async {
    // 내 bucketList 가져오기
    return fishingCollection.where('email', isEqualTo: email).get();
  }

  void create(String email, Timestamp date, String timeString) async {
    await fishingCollection.add({
      'email': email,
      'date': date,
      'duration': timeString,
    });
    notifyListeners();
  }
}
