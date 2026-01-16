import 'package:flutter/material.dart';
import '../models/dua_model.dart';

/// Sample collection of daily Islamic duas/prayers
final List<Dua> sampleDuas = [
  Dua(
    id: 1,
    title: 'Doa Bangun Tidur',
    doa: 'اَلْحَمْدُ لِلَّهِ الَّذِىْ أَحْيَانَا بَعْدَمَآ أَمَاتَنَا وَإِلَيْهِ النُّشُوْرُ',
    rumi: 'Alhamdulillahil-ladzi ahyana ba\'dama amatana wa ilaihin-nusyur',
    maksud: 'Segala puji bagi Allah yang menghidupkan kami setelah mematikan kami dan kepada-Nya akan kembali.',
  ),
  Dua(
    id: 2,
    title: 'Doa Sebelum Tidur',
    doa: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    rumi: 'Bismika Allahumma amutu wa ahya',
    maksud: 'Dengan nama-Mu ya Allah aku mati dan aku hidup.',
  ),
  Dua(
    id: 3,
    title: 'Doa Sebelum Makan',
    doa: 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
    rumi: 'Bismillahi wa \'ala barakatillah',
    maksud: 'Dengan nama Allah dan dengan berkat Allah.',
  ),
  Dua(
    id: 4,
    title: 'Doa Selepas Makan',
    doa: 'اَلْحَمْدُ لِلَّهِ الَّذِىْ أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مِنَ الْمُسْلِمِينَ',
    rumi: 'Alhamdulillahil-ladzi at\'amana wasaqana waja\'alana minal muslimin',
    maksud: 'Segala puji bagi Allah yang telah memberi kami makan dan minum serta menjadikan kami orang Islam.',
  ),
  Dua(
    id: 5,
    title: 'Doa Masuk Tandas',
    doa: 'اَللَّهُمَّ إِنِّى أَعُوذُبِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
    rumi: 'Allahumma inni a\'uzubika minal khubutsi wal khabaa-its',
    maksud: 'Ya Allah, sesungguhnya aku berlindung dengan-Mu daripada syaitan lelaki dan perempuan.',
  ),
  Dua(
    id: 6,
    title: 'Doa Keluar Tandas',
    doa: 'غُفْرَانَكَ اَلْحَمْدُ لِلَّهِ الَّذِي أَذْهَبَ عَنِّي اَلأَذَى وَعَافَانِي',
    rumi: 'Ghufranaka alhamdulillahil-ladzi azhaba \'annil aza wa \'afani',
    maksud: 'Ampunilah daku, Segala puji bagi Allah yang telah menghilangkan gangguan daripadaku serta menyembuhkanku.',
  ),
  Dua(
    id: 7,
    title: 'Doa Masuk Rumah',
    doa: 'بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا وَعَلَى رَبِّنَا تَوَكَّلْنَا',
    rumi: 'Bismillahi walajna, wa bismillahi kharajna, wa \'ala Rabbina tawakkalna',
    maksud: 'Dengan nama Allah kami masuk, dengan nama Allah kami keluar, dan kepada Tuhan kami bertawakkal.',
  ),
  Dua(
    id: 8,
    title: 'Doa Keluar Rumah',
    doa: 'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ',
    rumi: 'Bismillahi tawakkaltu \'alallahi la hawla wa la quwwata illa billah',
    maksud: 'Dengan nama Allah, aku bertawakkal kepada Allah, tidak ada daya dan kekuatan melainkan dengan pertolongan Allah.',
  ),
  Dua(
    id: 9,
    title: 'Doa Untuk Ibu Bapa',
    doa: 'رَبِّ اغْفِرْلِى وَلِوَالِدَىَّ وَارْحَمْهُمَا كَمَا رَبَّيَانِىْ صَغِيْرًا',
    rumi: 'Rabbighfir li wa liwalidayya warhamhuma kama rabbayani saghira',
    maksud: 'Ya Tuhanku, ampunilah dosaku dan dos kedua ibu bapaku serta rahmatilah mereka sebagaimana mereka memeliharaku di waktu kecil.',
  ),
  Dua(
    id: 10,
    title: 'Doa Sebelum Belajar',
    doa: 'رَبِّ زِدْنِىْ عِلْمًا وَارْزُقْنِىْ فَهْمًا',
    rumi: 'Rabbi zidni \'ilma warzuqni fahma',
    maksud: 'Ya Tuhanku, tambahkanlah ilmuku dan berilah aku kefahaman.',
  ),
];

/// Doa Screen - Islamic prayers collection
class DoaScreen extends StatelessWidget {
  const DoaScreen({super.key});

  static const Color colorPrimary = Color(0xFF6A1B9A);
  static const Color colorAccent = Color(0xFFAD1457);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0A2E), Color(0xFF2D1F4A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sampleDuas.length,
                  itemBuilder: (context, index) => _buildDuaCard(context, sampleDuas[index], index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doa Harian',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Daily Prayers Collection',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorPrimary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Text('🤲', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }


  Widget _buildDuaCard(BuildContext context, Dua dua, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 50),
      builder: (_, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colorPrimary, colorAccent]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${dua.id}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              dua.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            iconColor: Colors.white54,
            collapsedIconColor: Colors.white38,
            children: [
              // Arabic text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dua.doa,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    height: 2,
                    fontFamily: 'serif',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Transliteration
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transliteration',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dua.rumi,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Meaning
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meaning',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dua.maksud,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
