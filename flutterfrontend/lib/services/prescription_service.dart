import 'dart:io';
import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/prescription.dart';

class PrescriptionService {
  final DioClient _dio;

  PrescriptionService({DioClient? dio}) : _dio = dio ?? DioClient();

  Future<Prescription> uploadPrescription({
    required File file,
    String? notes,
  }) async {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
      if (notes != null) 'notes': notes,
    });
    final response = await _dio.upload(ApiConstants.prescriptions, formData);
    return Prescription.fromJson(response.data);
  }

  Future<List<Prescription>> getPrescriptions() async {
    final response = await _dio.get(ApiConstants.prescriptions);
    final data = response.data;
    final List results = data is List ? data : (data['results'] ?? data['data'] ?? []);
    return results.map((e) => Prescription.fromJson(e)).toList();
  }

  Future<Prescription> getPrescriptionDetail(int id) async {
    final response = await _dio.get('${ApiConstants.prescriptions}$id/');
    return Prescription.fromJson(response.data);
  }

  Future<void> deletePrescription(int id) async {
    await _dio.delete('${ApiConstants.prescriptions}$id/');
  }
}
