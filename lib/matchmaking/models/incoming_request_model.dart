class IncomingRequestModel {
  final int requestId;
  final int senderId;
  final String senderUsername;
  final String senderRank;
  final String senderLokasi;
  final String senderAvatar;
  final dynamic senderInstagram;
  final String timestamp;

  IncomingRequestModel({
    required this.requestId,
    required this.senderId,
    required this.senderUsername,
    required this.senderRank,
    required this.senderLokasi,
    required this.senderAvatar,
    required this.senderInstagram,
    required this.timestamp,
  });

  factory IncomingRequestModel.fromJson(Map<String, dynamic> json) {
    return IncomingRequestModel(
      requestId: json['request_id'],
      senderId: json['sender_id'],
      senderUsername: json['sender_username'],
      senderRank: json['sender_rank'],
      senderLokasi: json['sender_lokasi'],
      senderAvatar: json['sender_avatar'],
      senderInstagram: json['sender_instagram'],
      timestamp: json['timestamp'],
    );
  }
}
