import 'dart:convert';
import 'package:cardholderapp/model/cardModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CardStorageService {
  static const _key = "saved_cards";
  final _storage = const FlutterSecureStorage();

  Future<void> saveCard(CardModel card) async {
    final existing = await getCards();
    existing.add(card);
    final jsonList = existing.map((e) => e.toJson()).toList();

    await _storage.write(key: _key, value: jsonEncode(jsonList));
  }

  Future<List<CardModel>> getCards() async {
    final data = await _storage.read(key: _key);

    if (data == null) return [];

    final List decoded = jsonDecode(data);
    return decoded.map((e) => CardModel.fromJson(e)).toList();
  }

  Future<void> editCard(String oldNumber, CardModel newCard) async {
    List<CardModel> cards = await getCards();

    final index = cards.indexWhere((c) => c.number == oldNumber);
    if (index != -1) {
      cards[index] = newCard;
      await _saveCards(cards); // _saveCards() mevcut listeyi kaydediyor
    }
  }

  Future<void> _saveCards(List<CardModel> cards) async {
    List<Map<String, dynamic>> jsonList = cards.map((c) => c.toJson()).toList();
    await _storage.write(key: _key, value: json.encode(jsonList));
  }

  Future<void> deleteCard(String cardNumber) async {
    // Kartı number ile sil
    List<CardModel> cards = await getCards();
    cards.removeWhere((c) => c.number == cardNumber);
    // Geri kaydet (shared preferences veya local DB)
    final jsonList = cards.map((e) => e.toJson()).toList();
    await _storage.write(key: _key, value: jsonEncode(jsonList));
  }
}
