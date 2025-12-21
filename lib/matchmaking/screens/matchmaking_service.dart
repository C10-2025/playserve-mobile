import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class MatchmakingService {
  final CookieRequest request;

  MatchmakingService(this.request);

  // Ambil pemain yang bisa di-invite
  Future<List<dynamic>> getAvailableUsers() async {
    final response = await request.get(
      "http://127.0.0.1:8000/matchmaking/api/available-users/",
    );
    return response['users'] ?? [];
  }

  // Ambil request masuk
  Future<List<dynamic>> getIncomingRequests() async {
    final response = await request.get(
      "http://127.0.0.1:8000/matchmaking/api/incoming-requests/",
    );
    return response['requests'] ?? [];
  }

  // Mengirim permintaan match
  Future<Map<String, dynamic>> createRequest(int receiverId) async {
    return await request.postJson(
      "http://127.0.0.1:8000/matchmaking/action/create-request/",
      jsonEncode({"receiver_id": receiverId}),
    );
  }

  // Accept atau reject request
  Future<Map<String, dynamic>> handleRequest(
    int requestId,
    String action,
  ) async {
    return await request.postJson(
      "http://127.0.0.1:8000/matchmaking/action/handle-request/",
      jsonEncode({"request_id": requestId, "action": action}),
    );
  }

  // Cek apakah user sedang dalam sesi match aktif
  Future<Map<String, dynamic>> getActiveSession() async {
    return await request.get(
      "http://127.0.0.1:8000/matchmaking/api/active-session/",
    );
  }

  // Selesaikan pertandingan
  Future<Map<String, dynamic>> finishSession(
    int sessionId,
    String action,
  ) async {
    return await request.postJson(
      "http://127.0.0.1:8000/matchmaking/action/finish-session/",
      jsonEncode({"session_id": sessionId, "action": action}),
    );
  }
}
