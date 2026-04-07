import 'package:cardholderapp/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Eger Google Fonts paketini eklersen (onerilir), yorum satirini kaldir:
// import 'package:google_fonts/google_fonts.dart';

void main() {
  // 1. SYSTEM UI: Durum çubuğunu (Status Bar) tamamen şeffaf ve entegre yapıyoruz.
  // Bu, tam ekran deneyimini (Sliver'lar ile) kusursuzlaştırır.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Tamamen şeffaf
      statusBarIconBrightness:
          Brightness.dark, // İkonlar koyu (açık arka plan için)
      systemNavigationBarColor: Color(0xFFF8F9FA), // Alt navigasyon bar rengi
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. DESIGN SYSTEM CONSTANTS: Temel tasarım kararlarını değişkenlere atayalım.
    // Bu, uygulama genelinde tutarlılık sağlar.
    const kPrimaryRed = Color(0xFFE53935); // Canlı, güven veren bir kırmızı
    const kNeutralBlack = Color(
      0xFF1E1E1E,
    ); // Saf siyah yerine daha yumuşak antrasit
    const kBackgroundGrey = Color(0xFFF8F9FA); // Nefes alan, ferah arka plan
    const kTextSecondary = Color(0xFF757575); // Yardımcı metinler için gri

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Card Wallet Pro',
      theme: ThemeData(
        useMaterial3: true,

        // 3. COLOR SCHEME: Modern M3 renk paleti.
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryRed,
          primary: kPrimaryRed,
          secondary: kNeutralBlack,
          surface: Colors.white,
          background: kBackgroundGrey,
          error: const Color(0xFFD32F2F),
        ),

        // 4. TYPOGRAPHY: Sofistike ve okunabilir yazı tipi hiyerarşisi.
        // Google Fonts paketini ekleyip 'Poppins' veya 'Inter' kullanman harika olur.
        // Eğer eklemezsen varsayılan sistem fontu modern kalır.
        // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).copyWith( ... ),
        textTheme: const TextTheme(
          // Ana başlıklar (Örn: Cüzdanım)
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: kNeutralBlack,
            letterSpacing: -1.0,
          ),
          // Kart üzerindeki isimler, alt başlıklar
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kNeutralBlack,
            letterSpacing: -0.5,
          ),
          // Form etiketleri (LABEL)
          labelMedium: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: kNeutralBlack,
            letterSpacing: 0.5,
          ),
          // Açıklama metinleri
          bodyMedium: TextStyle(
            fontSize: 15,
            color: kTextSecondary,
            height: 1.6,
          ),
        ),

        // 5. APPBAR: İçerikle bütünleşen, şeffaf ve minimalist üst bar.
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation:
              0, // Kaydırınca oluşan gölgeyi modern M3 kontrol eder (kapalı)
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: kNeutralBlack,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1, // Hafif açık harf arası
          ),
          iconTheme: IconThemeData(color: kNeutralBlack, size: 24),
        ),

        // 6. BUTTONS: Konforlu, geniş ve şık butonlar.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                kNeutralBlack, // Modern: Ana buton siyah, FAB kırmızı
            foregroundColor: Colors.white,
            minimumSize: const Size(
              double.infinity,
              60,
            ), // Daha yüksek, dokunması kolay
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20,
              ), // Daha yumuşak, M3 tarzı köşeler
            ),
            elevation: 0, // Düz tasarım, derinliği FAB ve Kartlar verir
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
            // Mikro etkileşim: Tıklama anındaki efekt
            splashFactory: InkSparkle.splashFactory,
          ),
        ),

        // 7. INPUTS (FORMS): Glassmorphism (Cam) esintili, temiz ve odaklanmış formlar.
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white, // Form arka planı saf beyaz
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          // Varsayılan kenarlık (Hafif gri)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.grey.shade100),
          ),
          // Boşken kenarlık (Neredeyse görünmez)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.grey.shade50),
          ),
          // Odaklandığında (Kırmızı ve belirgin)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: kPrimaryRed, width: 2.0),
          ),
          // Hata anında
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
          ),
          labelStyle: const TextStyle(
            color: kTextSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          floatingLabelBehavior:
              FloatingLabelBehavior.never, // Daha minimalist formlar için
        ),

        // 9. FLOATING ACTION BUTTON (FAB): Dikkat çeken ana eylem butonu.
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kPrimaryRed,
          foregroundColor: Colors.white,
          elevation: 10,
          focusElevation: 12,
          hoverElevation: 12,
          disabledElevation: 0,
          highlightElevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          extendedTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      // Başlığı "Cüzdanım" yaparak daha kapsayıcı bir ton seçtik.
      home: const HomePage(title: 'Cüzdanım'),
    );
  }
}
