class Booking {
  final int id;
  final BookingField field;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final double durationHours;
  final double totalPrice;
  final String status;
  final String? notes;
  final String bookerName;
  final String bookerPhone;
  final String? bookerEmail;
  final String? paymentProofUrl;
  final String? createdAt;
  final String? confirmedAt;
  final String? cancelledAt;
  final bool? canCancel;

  Booking({
    required this.id,
    required this.field,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.totalPrice,
    required this.status,
    required this.notes,
    required this.bookerName,
    required this.bookerPhone,
    required this.bookerEmail,
    required this.paymentProofUrl,
    required this.createdAt,
    required this.confirmedAt,
    required this.cancelledAt,
    required this.canCancel,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json["id"] ?? 0,
      field: BookingField.fromJson(json["field"] ?? {}),
      bookingDate: json["booking_date"] ?? "",
      startTime: json["start_time"] ?? "",
      endTime: json["end_time"] ?? "",
      durationHours: (json["duration_hours"] as num).toDouble(),
      totalPrice: (json["total_price"] as num).toDouble(),
      status: json["status"] ?? "",
      notes: json["notes"],
      bookerName: json["booker_name"] ?? "",
      bookerPhone: json["booker_phone"] ?? "",
      bookerEmail: json["booker_email"],
      paymentProofUrl: json["payment_proof_url"],
      createdAt: json["created_at"],
      confirmedAt: json["confirmed_at"],
      cancelledAt: json["cancelled_at"],
      canCancel: json["can_cancel"],
    );
  }
}

class BookingField {
  final int id;
  final String name;
  final String city;
  final String? imageUrl;
  final String? courtImage;

  BookingField({
    required this.id,
    required this.name,
    required this.city,
    required this.imageUrl,
    required this.courtImage,
  });

  factory BookingField.fromJson(Map<String, dynamic> json) {
    return BookingField(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      city: json["city"] ?? "",
      imageUrl: json["image_url"],
      courtImage: json["court_image"],
    );
  }
}
