import 'dart:convert';
import 'package:aplikasi_manajemen_kesehatan/helpers/api.dart';
import 'package:aplikasi_manajemen_kesehatan/helpers/api_url.dart';
import 'package:aplikasi_manajemen_kesehatan/model/kesehatan_mental.dart';

class KesehatanMentalBloc {
  // Mendapatkan daftar data kesehatan mental
  static Future<List<KesehatanMental>> getDataKesehatanMental() async {
    String apiUrl = ApiUrl.listKesehatanMental;
    var response = await Api().get(apiUrl);

    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      List<dynamic> listKesehatanMental =
          (jsonObj as Map<String, dynamic>)['data'];
      List<KesehatanMental> kesehatanMentalList = [];

      for (var item in listKesehatanMental) {
        kesehatanMentalList.add(KesehatanMental.fromJson(item));
      }
      return kesehatanMentalList;
    } else {
      throw Exception('Gagal mendapatkan data: ${response.statusCode}');
    }
  }

  // Menambahkan data kesehatan mental
  static Future<bool> addDataKesehatanMental(
      {required KesehatanMental kesehatanMental}) async {
    String apiUrl = ApiUrl.createKesehatanMental;

    var body = {
      "mental_state": kesehatanMental.mentalState,
      "therapy_sessions": kesehatanMental.therapySessions.toString(),
      "medication": kesehatanMental.medication,
    };

    var response = await Api().post(apiUrl, body);

    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      return jsonObj['status'] == true; // Memastikan status respons
    } else {
      throw Exception('Gagal menambahkan data: ${response.statusCode}');
    }
  }

  // Memperbarui data kesehatan mental
  static Future<bool> updateDataKesehatanMental(
      {required KesehatanMental kesehatanMental}) async {
    if (kesehatanMental.id == null) {
      throw Exception("ID tidak boleh null untuk memperbarui data.");
    }

    String apiUrl = ApiUrl.updateKesehatanMental(kesehatanMental.id!);

    var body = {
      "mental_state": kesehatanMental.mentalState,
      "therapy_sessions": kesehatanMental.therapySessions.toString(),
      "medication": kesehatanMental.medication,
    };

    var response = await Api().put(apiUrl, jsonEncode(body));

    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      return jsonObj['status'] == true; // Memastikan status respons
    } else {
      throw Exception('Gagal memperbarui data: ${response.statusCode}');
    }
  }

  // Menghapus data kesehatan mental
  static Future<bool> deleteDataKesehatanMental({required int id}) async {
    String apiUrl = ApiUrl.deleteKesehatanMental(id);
    var response = await Api().delete(apiUrl);

    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      return (jsonObj as Map<String, dynamic>)['status'] ==
          true; // Pastikan memeriksa 'status'
    } else {
      throw Exception('Gagal menghapus data: ${response.statusCode}');
    }
  }
}
