import 'package:firebase_database/firebase_database.dart';

class MedicineStatus {
  // Retrieve data
  Future<String> retrieveData() async {
    String _result = "err";

    await FirebaseDatabase.instance
        .reference()
        .child('medicine_status')
        .once()
        .then((value) {
      // print(value.value);

      Map<dynamic, dynamic> result = value.value;

      result.forEach((key, value) {
        // print(key);
        // print(value);
        if (value == 0)
          _result = 'Tidak ada notifikasi';
        else if (value == 1)
          _result = 'Waktunya minum obat';
        else if (value == 2)
          _result = 'Obat belum diambil';
        else if (value == 3) _result = 'Obat sudah diambil';
      });
    });

    return _result;
  }
}

MedicineStatus medicineStatus = new MedicineStatus();
