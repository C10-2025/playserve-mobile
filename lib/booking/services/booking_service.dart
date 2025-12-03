import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../models/availability.dart';
import '../models/booking.dart';
import '../models/playing_field.dart';

class BookingService {
  // Default to localhost (use 10.0.2.2 when running on Android emulator)
  BookingService(this.request, {this.baseUrl = 'http://localhost:8000'});

  final CookieRequest request;
  final String baseUrl;

  Future<List<PlayingFieldItem>> fetchFields() async {
    final url = '$baseUrl/booking/api/fields/';
    final response = await request.get(url);
    if (response is Map && response['data'] != null) {
      final raw = response['data'];
      return List<PlayingFieldItem>.from(
        (raw as List<dynamic>).map((x) => PlayingFieldItem.fromJson(x)),
      );
    }
    // Fallback if endpoint returns raw list
    if (response is List) {
      return List<PlayingFieldItem>.from(
        response.map((x) => PlayingFieldItem.fromJson(x)),
      );
    }
    throw Exception('Failed to load fields');
  }

  Future<AvailabilityResponse> checkAvailability({
    required int fieldId,
    required String date, // YYYY-MM-DD
    required String startTime, // HH:MM
    required String endTime, // HH:MM
  }) async {
    final url =
        '$baseUrl/booking/api/availability/?field_id=$fieldId&date=$date&start_time=$startTime&end_time=$endTime';
    final response = await request.get(url);
    return AvailabilityResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<BookingItem> createBooking({
    required int fieldId,
    required String bookingDate,
    required String startTime,
    required String endTime,
    required String bookerName,
    required String bookerPhone,
    String? bookerEmail,
    String? notes,
  }) async {
    final url = '$baseUrl/booking/api/book/';
    final payload = jsonEncode({
      "field_id": fieldId,
      "booking_date": bookingDate,
      "start_time": startTime,
      "end_time": endTime,
      "booker_name": bookerName,
      "booker_phone": bookerPhone,
      "booker_email": bookerEmail ?? "",
      "notes": notes ?? "",
    });
    final response = await request.postJson(url, payload);
    if (response is Map && response['status'] == 'success') {
      return BookingItem.fromJson(response['data']);
    }
    throw Exception(response is Map ? response['message'] ?? 'Booking failed' : 'Booking failed');
  }

  Future<List<BookingItem>> fetchMyBookings() async {
    final url = '$baseUrl/booking/api/my-bookings/';
    final response = await request.get(url);
    if (response is Map && response['data'] != null) {
      return List<BookingItem>.from(
        (response['data'] as List<dynamic>).map((x) => BookingItem.fromJson(x)),
      );
    }
    throw Exception('Failed to load bookings');
  }

  Future<void> cancelBooking(int bookingId) async {
    final url = '$baseUrl/booking/api/cancel/';
    final payload = jsonEncode({"booking_id": bookingId});
    final response = await request.postJson(url, payload);
    if (response is Map && response['status'] == 'success') {
      return;
    }
    throw Exception(response is Map ? response['message'] ?? 'Cancel failed' : 'Cancel failed');
  }
}
