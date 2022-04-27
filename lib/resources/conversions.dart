import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Conversions {
  static convertTimeStamp(Timestamp timestamp) {
    if (timestamp.toString().isEmpty) {
      return;
    }
    String convertedDate =
        DateFormat.yMMMd().add_jm().format(timestamp.toDate());
    return convertedDate;
  }
}
