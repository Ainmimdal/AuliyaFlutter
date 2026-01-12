import 'package:flutter/material.dart';
import '../models/dua_model.dart';

class DuaScreen extends StatelessWidget {
  const DuaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for now
    final duas = [
      Dua(
        id: 1, 
        title: "Doa Sebelum Tidur", 
        doa: "بِسْمِكَ اللّهُمَّ أَحْيَا وَأَمُوتُ", 
        rumi: "Bismika Allahumma ahya wa amutu", 
        maksud: "Dengan nama-Mu, Ya Allah, aku hidup dan aku mati."
      ),
      Dua(
        id: 2, 
        title: "Doa Bangun Tidur", 
        doa: "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ", 
        rumi: "Alhamdulillahilladzi ahyana ba'da ma amatana wa ilaihin nusyur", 
        maksud: "Segala puji bagi Allah yang menghidupkan kami selepas mematikan kami dan kepada-Nya kami akan kembali."
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Himpunan Doa")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: duas.length,
        separatorBuilder: (_,__) => const Divider(),
        itemBuilder: (context, index) {
          final dua = duas[index];
          return Card(
            child: ExpansionTile(
              title: Text(dua.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(dua.doa, style: const TextStyle(fontSize: 24, fontFamily: 'Amiri'), textAlign: TextAlign.center), // Use Arabic font if available
                      const SizedBox(height: 10),
                      Text(dua.rumi, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                      const SizedBox(height: 10),
                      Text(dua.maksud, textAlign: TextAlign.center),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
