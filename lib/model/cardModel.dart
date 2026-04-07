// ignore: file_names
import 'dart:convert';

class CardModel {
  final String name;
  final String number;
  final String expiry;
  final String cvv;

  CardModel({
    required this.name,
    required this.number,
    required this.expiry,
    required this.cvv,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "number": number,
    "expiry": expiry,
    "cvv": cvv,
  };

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
    name: json["name"],
    number: json["number"],
    expiry: json["expiry"],
    cvv: json["cvv"],
  );

  // --- Listeyi JSON string’e çevir ---
  static String encodeCards(List<CardModel> cards) {
    return jsonEncode(cards.map((c) => c.toJson()).toList());
  }

  // --- JSON string’i listeye çevir ---
  static List<CardModel> decodeCards(String cardsJson) {
    final List<dynamic> decoded = jsonDecode(cardsJson);
    return decoded.map((json) => CardModel.fromJson(json)).toList();
  }
}
