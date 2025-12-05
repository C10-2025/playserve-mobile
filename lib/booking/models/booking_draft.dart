import 'package:playserve_mobile/booking/models/playing_field.dart';

class BookingDraft {
  BookingDraft({required this.field});

  final PlayingField field;
  String? bookerName;
  String? bookerPhone;
  String? bookerEmail;
  DateTime? bookingDate;
  String? startTime; // HH:mm
  double? durationHours;
  String? notes;
}
