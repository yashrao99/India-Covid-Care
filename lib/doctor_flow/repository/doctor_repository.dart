import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:india_covid_care/network/base_api_manager.dart';
import 'package:india_covid_care/network/patient_details.dart';

class DoctorRepository {
  final BaseAPIManager apiClient = BaseAPIManager();

  Future<List<PatientDetails>> getPatients() async {
    try {
      final response = await apiClient.get(CovidCareEndpoints.getPatients);
      final decoded = jsonDecode(response.body.toString()) as List<dynamic>;
      print('Here is decoded: $decoded');
      final List<PatientDetails> patients = decoded
          .map((patientJson) => PatientDetails.fromJson(patientJson))
          .toList();
      return patients;
    } catch (error) {
      print('Here is error: $error');
      return Future.error('Error with GetPatients: $error');
    }
  }

  Future<void> postDoctorCall(
      String name, String location, String id, String number) async {
    try {
      final resp = await apiClient.post(CovidCareEndpoints.markAsComplete,
          {'doctor': name, 'doctorLocation': location}, {'id': id});
      if (resp.statusCode != 200) {
        return Future.error(
            'Invalid status code updating DocInfo: ${resp.statusCode}');
      }
      return Future.value();
    } catch (error) {
      print("Error updating Doctor Information on Call : $error");
      return Future.error('Error updating Doctor Information pre call: $error');
    }
  }

  Future<void> markAsCompleted(String id) async {
    try {
      final response = await apiClient.post(
          CovidCareEndpoints.markAsComplete, {'attended': 'true'}, {'id': id});
      if (response.statusCode != 200) {
        throw HttpException(
            'Invalid MarkAsCompleted, statusCode not 200. ${response.statusCode}');
      }
      return Future.value();
    } catch (error) {
      return Future.error('error with marking patient as resolved: $error');
    }
  }
}
