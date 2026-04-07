import 'package:flutter/material.dart';
import 'package:cardholderapp/addCardPage.dart';
import 'package:cardholderapp/model/cardModel.dart';
import 'package:cardholderapp/service/cardStorageService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CardStorageService _storageService = CardStorageService();
  late Future<List<CardModel>> _cardsFuture;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() {
    setState(() {
      _cardsFuture = _storageService.getCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.8, -0.8),
            radius: 1.5,
            colors: [Colors.red.withOpacity(0.05), Colors.white],
          ),
        ),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              elevation: innerBoxIsScrolled ? 2 : 0,
              backgroundColor: innerBoxIsScrolled
                  ? Colors.white.withOpacity(0.9)
                  : Colors.transparent,
              centerTitle: true,
              title: Text(
                widget.title.toUpperCase(),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: innerBoxIsScrolled ? 16 : 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: () {},
                ),
              ],
            ),
          ],
          body: FutureBuilder<List<CardModel>>(
            future: _cardsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFE53935)),
                );
              } else if (snapshot.hasError) {
                return _buildErrorState(snapshot.error.toString());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState();
              }

              final cards = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                itemCount: cards.length,
                itemBuilder: (context, index) =>
                    _buildCardItem(cards[index], index),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildAddCardFAB(),
    );
  }

  Widget _buildCardItem(CardModel card, int index) {
    final List<List<Color>> gradients = [
      [const Color(0xFF2D3436), Colors.black],
      [const Color(0xFFE53935), const Color(0xFFB71C1C)],
      [const Color(0xFF4834d4), const Color(0xFF686de0)],
    ];
    final gradient = gradients[index % gradients.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Dismissible(
        key: Key(card.number),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(Icons.edit, color: Colors.white),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            // Silme
            bool? confirmed = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Kartı Sil"),
                content: const Text(
                  "Bu kartı silmek istediğinizden emin misiniz?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("İptal"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Sil"),
                  ),
                ],
              ),
            );
            if (confirmed == true) {
              await _storageService.deleteCard(card.number);
              _loadCards();
            }
            return confirmed;
          } else if (direction == DismissDirection.startToEnd) {
            // Düzenleme
            final updatedCard = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddCardPage(editCard: card),
              ),
            );
            if (updatedCard != null) {
              _cardsFuture = _storageService.getCards();
              setState(() {});
            }
            return false; // kaydırmayı tamamlamıyoruz
          }
          return false;
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: gradient.last.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.contactless_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      Text(
                        card.number.startsWith('4') ? "VISA" : "Mastercard",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    card.number
                        .replaceAllMapped(
                          RegExp(r".{4}"),
                          (m) => "${m.group(0)} ",
                        )
                        .trim(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 2,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCardInfo("KART SAHİBİ", card.name.toUpperCase()),
                      _buildCardInfo("S.K.T", card.expiry),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.1),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Cüzdanınız Boş",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Henüz bir kart eklemediniz. Hemen bir tane ekleyin.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCardFAB() {
    return Container(
      height: 65,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF2D3436), Color(0xFFE53935)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddCardPage()),
            );
            _loadCards();
          },
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 28),
                SizedBox(width: 10),
                Text(
                  "YENİ KART EKLE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Text("Hata: $error", style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Color(0xFF2D3436),
              borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
            ),
            accountName: const Text(
              "Kullanıcı Adı",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: const Text(
              "premium@cardwallet.com",
              style: TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person_rounded,
                color: Colors.red[700],
                size: 45,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _drawerItem(
            Icons.credit_card_rounded,
            "Kartlarım",
            true,
            () => Navigator.pop(context),
          ),
          _drawerItem(
            Icons.analytics_outlined,
            "Harcama Analizi",
            false,
            () => Navigator.pop(context),
          ),
          _drawerItem(
            Icons.security_rounded,
            "Güvenlik",
            false,
            () => Navigator.pop(context),
          ),
          const Divider(indent: 20, endIndent: 20, height: 40),
          _drawerItem(
            Icons.settings_outlined,
            "Ayarlar",
            false,
            () => Navigator.pop(context),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: 14, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  "v1.0.2 Premium",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String text,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.red.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFFE53935) : Colors.black54,
          size: 24,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xFFE53935) : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
        trailing: isSelected
            ? Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            : null,
      ),
    );
  }
}
