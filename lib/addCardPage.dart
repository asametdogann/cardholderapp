import 'package:cardholderapp/model/cardModel.dart';
import 'package:cardholderapp/service/cardStorageService.dart';
import 'package:flutter/material.dart';

class AddCardPage extends StatefulWidget {
  final dynamic editCard;

  const AddCardPage({super.key, this.editCard});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Eğer düzenleme modundaysa verileri doldur
    if (widget.editCard != null) {
      final card = widget.editCard as CardModel;
      _nameController.text = card.name;
      _numberController.text = card.number;
      _expiryController.text = card.expiry;
      _cvvController.text = card.cvv;
    }

    // Canlı önizleme için listener
    _nameController.addListener(() => setState(() {}));
    _numberController.addListener(() => setState(() {}));
    _expiryController.addListener(() => setState(() {}));
    _cvvController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Yeni Kart Ekle",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // --- INTERAKTIF SANAL KART ---
              _buildCreditCardPreview(),

              const SizedBox(height: 30),

              // --- FORM ALANLARI ---
              _buildModernTextField(
                controller: _nameController,
                label: "Kart Sahibi",
                hint: "AD SOYAD",
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                controller: _numberController,
                label: "Kart Numarası",
                hint: "0000 0000 0000 0000",
                icon: Icons.credit_card_rounded,
                keyboardType: TextInputType.number,
                maxLength: 16,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildModernTextField(
                      controller: _expiryController,
                      label: "S.K. Tarihi",
                      hint: "AA/YY",
                      icon: Icons.calendar_today_rounded,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModernTextField(
                      controller: _cvvController,
                      label: "CVV",
                      hint: "123",
                      icon: Icons.lock_outline_rounded,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // --- KAYDET BUTONU ---
              _buildSaveButton(),
              const SizedBox(height: 10),
              // --- GÜVENLİK ROZETİ ---
              _buildSecurityBadge(),
            ],
          ),
        ),
      ),
    );
  }

  // --- GÜVENLİK ROZETİ ---
  Widget _buildSecurityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_user_rounded,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            "256-bit SSL Güvenli İşlem",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // --- KART ÖNİZLEME TASARIMI ---
  Widget _buildCreditCardPreview() {
    return Container(
      height: 210,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF2D3436), Color(0xFFE53935)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: const Color(0xFFE53935).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.contactless, color: Colors.white, size: 32),
              Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/2560px-Visa_Inc._logo.svg.png",
                height: 20,
                color: Colors.white,
                errorBuilder: (c, e, s) =>
                    const Icon(Icons.credit_card, color: Colors.white),
              ),
            ],
          ),
          const Spacer(),
          Text(
            _numberController.text.isEmpty
                ? "XXXX XXXX XXXX XXXX"
                : _numberController.text.replaceAllMapped(
                    RegExp(r".{4}"),
                    (match) => "${match.group(0)} ",
                  ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
              fontFamily: 'Courier',
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cardInfoLabel(
                "KART SAHİBİ",
                _nameController.text.isEmpty
                    ? "AD SOYAD"
                    : _nameController.text.toUpperCase(),
              ),
              _cardInfoLabel(
                "S.K.T",
                _expiryController.text.isEmpty
                    ? "00/00"
                    : _expiryController.text,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardInfoLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // --- MODERN INPUT TASARIMI ---
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  $label",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFFE53935)),
            counterText: "",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE53935),
                width: 1.5,
              ),
            ),
          ),
          validator: (value) =>
              (value == null || value.isEmpty) ? "Zorunlu alan" : null,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    final isEditing = widget.editCard != null;

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Colors.black, Color(0xFFE53935)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final card = CardModel(
              name: _nameController.text,
              number: _numberController.text,
              expiry: _expiryController.text,
              cvv: _cvvController.text,
            );

            final storageService = CardStorageService();

            if (isEditing) {
              await storageService.editCard(widget.editCard.number, card);
            } else {
              await storageService.saveCard(card);
            }

            Navigator.pop(
              context,
              card,
            ); // Düzenlenmiş veya yeni kartı geri döndür
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          isEditing ? "KARTI GÜNCELLE" : "KARTI SİSTEME EKLE",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
