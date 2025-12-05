import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/availability.dart';
import '../models/booking.dart';
import '../models/playing_field.dart';

class BookingService {
  BookingService(this.request, {this.baseUrl = 'http://localhost:8000'});
  final CookieRequest request;
  final String baseUrl;

  Future<List<PlayingField>> fetchFields() async {
    final response = await request.get('$baseUrl/booking/api/fields/');
    final data = (response is Map && response['data'] != null) ? response['data'] : response;
    return List<PlayingField>.from((data as List).map((e) => PlayingField.fromJson(e)));
  }

  Future<AvailabilityResponse> checkAvailability({
    required int fieldId,
    required String date,
    required String startTime,
    required double durationHours,
    String? endTime,
  }) async {
    final endParam = endTime != null ? '&end_time=$endTime' : '';
    final response = await request.get(
        '$baseUrl/booking/api/availability/?field_id=$fieldId&date=$date&start_time=$startTime&duration_hours=$durationHours$endParam');
    return AvailabilityResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<Booking> createBooking({
    required int fieldId,
    required String bookingDate,
    required String startTime,
    required String endTime,
    required double durationHours,
    required String bookerName,
    required String bookerPhone,
    String? bookerEmail,
    String? notes,
  }) async {
    final Map<String, dynamic> payload = {
      "field_id": fieldId,
      "booking_date": bookingDate,
      "start_time": startTime,
      "end_time": endTime,
      "duration_hours": durationHours,
      "booker_name": bookerName,
      "booker_phone": bookerPhone,
      "booker_email": bookerEmail ?? "",
      "notes": notes ?? "",
    };
    // Send as JSON string to avoid bodyFields/content-type conflicts inside CookieRequest
    final response = await request.postJson('$baseUrl/booking/api/book/', jsonEncode(payload));
    if (response is Map && response['status'] == 'success') {
      return Booking.fromJson(response['data']);
    }
    if (response is Map) {
      throw Exception(response['message'] ?? 'Booking failed');
    }
    throw Exception('Booking failed (non-JSON response)');
  }

  Future<List<Booking>> fetchMyBookings() async {
    final response = await request.get('$baseUrl/booking/api/my-bookings/');
    final data = (response is Map && response['data'] != null) ? response['data'] : response;
    return List<Booking>.from((data as List).map((e) => Booking.fromJson(e)));
  }

  Future<void> uploadPaymentProof({
    required int bookingId,
    required File file,
  }) async {
    final uri = Uri.parse('$baseUrl/booking/api/bookings/$bookingId/upload-proof/');
    final req = http.MultipartRequest('POST', uri);
    // Only send cookie/CSRF; never send content-type
    final cookie = request.headers['Cookie'] ?? request.headers['cookie'];
    final csrf = request.headers['X-CSRFToken'] ?? request.headers['x-csrftoken'];
    if (cookie != null && cookie.isNotEmpty) {
      req.headers['Cookie'] = cookie;
    }
    if (csrf != null && csrf.isNotEmpty) {
      req.headers['X-CSRFToken'] = csrf;
    }
    req.files.add(await http.MultipartFile.fromPath('payment_proof', file.path));
    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    final parsed = jsonDecode(resp.body);
    if (!(resp.statusCode >= 200 && resp.statusCode < 300 && parsed['status'] == 'success')) {
      throw Exception(parsed['message'] ?? 'Upload failed');
    }
  }

  // Admin endpoints
  Future<List<PlayingField>> adminFetchFields() async {
    final resp = await request.get('$baseUrl/booking/api/admin/fields/');
    final data = (resp is Map && resp['data'] != null) ? resp['data'] : [];
    return List<PlayingField>.from((data as List).map((e) => PlayingField.fromJson(e)));
  }

  Future<PlayingField> adminCreateField(Map<String, String> payload) async {
    final resp = await request.post('$baseUrl/booking/api/admin/fields/create/', payload);
    if (resp is Map && resp['status'] == 'success') {
      return PlayingField.fromJson(resp['data']);
    }
    throw Exception('Failed to create field');
  }

  Future<PlayingField> adminUpdateField(int id, Map<String, String> payload) async {
    final resp = await request.post('$baseUrl/booking/api/admin/fields/$id/update/', payload);
    if (resp is Map && resp['status'] == 'success') {
      return PlayingField.fromJson(resp['data']);
    }
    throw Exception('Failed to update field');
  }

  Future<void> adminDeleteField(int id) async {
    final resp = await request.post('$baseUrl/booking/api/admin/fields/$id/delete/', {});
    if (!(resp is Map && resp['status'] == 'success')) {
      throw Exception('Failed to delete field');
    }
  }

  Future<List<Booking>> adminPendingBookings() async {
    final resp = await request.get('$baseUrl/booking/api/admin/pending-bookings/');
    final data = (resp is Map && resp['data'] != null) ? resp['data'] : [];
    return List<Booking>.from((data as List).map((e) => Booking.fromJson(e)));
  }

  Future<Booking> adminBookingDetail(int id) async {
    final resp = await request.get('$baseUrl/booking/api/admin/bookings/$id/');
    if (resp is Map && resp['status'] == 'success') {
      return Booking.fromJson(resp['data']);
    }
    throw Exception('Failed to load booking');
  }

  Future<Booking> adminVerifyBooking(int id, String decision, {String? notes}) async {
    final payload = {"decision": decision, "notes": notes ?? ""};
    final resp = await request.postJson('$baseUrl/booking/api/admin/bookings/$id/verify/', jsonEncode(payload));
    if (resp is Map && resp['status'] == 'success') {
      return Booking.fromJson(resp['data']);
    }
    throw Exception('Failed to verify booking');
  }
}
