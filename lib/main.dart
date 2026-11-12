import 'package:flutter/material.dart';

void main() => runApp(const KesproApp());

// ===== DATA GLOBAL (Biar tidak hilang pindah halaman) =====
class DataKespro {
  static List<Map<String, String>> pasienList = [
    {'nama': 'Siti Aminah', 'nik': '3171015502001234', 'kategori': 'Hamil', 'umur': '24', 'telp': '0812-3456-7890'},
    {'nama': 'Rina Putri', 'nik': '3171021205051234', 'kategori': 'Remaja', 'umur': '17', 'telp': '0813-1111-2222'},
  ];
  static List<Map<String, String>> ancList = [];
  static List<Map<String, String>> rujukanList = [];
}

class KesproApp extends StatelessWidget {
  const KesproApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KESPRO',
      theme: ThemeData(primarySwatch: Colors.pink, useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink)),
      home: const LoginScreen(),
    );
  }
}

Widget kesproIcon({double size = 90}) {
  return Container(
    width: size, height: size,
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFFFF7BA9), Color(0xFF6BB8FF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(22),
      boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
    ),
    child: Stack(alignment: Alignment.center, children: [
      const Icon(Icons.favorite, color: Colors.white, size: 52),
      const Icon(Icons.monitor_heart, color: Colors.white, size: 28),
      Positioned(bottom: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: const Text('KESPRO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.pink)))),
    ]),
  );
}

// ===== LOGIN =====
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginState();
}
class _LoginState extends State<LoginScreen> {
  final userC = TextEditingController(); final passC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      kesproIcon(size: 110),
      const SizedBox(height: 16),
      const Text('KESPRO', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.pink)),
      const Text('Remaja - Pranikah - Prakonsepsi - Hamil', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 30),
      TextField(controller: userC, decoration: const InputDecoration(labelText: 'Email / NIK Bidan', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
      const SizedBox(height: 12),
      TextField(controller: passC, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock))),
      const SizedBox(height: 8),
      const Text('Demo: isi apa saja, klik LOGIN', style: TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNav())), child: const Text('LOGIN', style: TextStyle(fontSize: 18)))),
    ])));
  }
}

// ===== NAVIGASI BAWAH =====
class MainNav extends StatefulWidget {
  const MainNav({super.key});
  @override
  State<MainNav> createState() => _MainNavState();
}
class _MainNavState extends State<MainNav> {
  int idx = 0;
  final pages = [const DashboardScreen(), const PasienListScreen(), const AncFormScreen(), const RujukanListScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(currentIndex: idx, onTap: (v) => setState(() => idx = v), type: BottomNavigationBarType.fixed, selectedItemColor: Colors.pink, items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pasien'),
        BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: 'ANC'),
        BottomNavigationBarItem(icon: Icon(Icons.local_hospital), label: 'Rujukan'),
      ]),
    );
  }
}

// ===== DASHBOARD =====
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    int totalPasien = DataKespro.pasienList.length;
    int totalAnc = DataKespro.ancList.length;
    int risiko = DataKespro.ancList.where((e) => e['hasil']!.contains('TINGGI')).length;
    return Scaffold(appBar: AppBar(title: Row(children: [kesproIcon(size: 32), const SizedBox(width: 8), const Text('KESPRO - Halo Bidan')]), backgroundColor: Colors.pink, foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(20), width: double.infinity, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.pink, Color(0xFF6BB8FF)]), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Hari ini: ${DateTime.now().day} Nov 2026', style: const TextStyle(color: Colors.white)), const SizedBox(height: 8), const Text('Semangat Melayani\nIbu & Remaja Sehat!', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))])),
        const SizedBox(height: 16),
        Row(children: [Expanded(child: _stat('$totalPasien', 'Total Pasien', Colors.blue)), const SizedBox(width: 10), Expanded(child: _stat('$totalAnc', 'Kunjungan ANC', Colors.green))]),
        const SizedBox(height: 10),
        Row(children: [Expanded(child: _stat('$risiko', 'Risiko Tinggi', Colors.red)), const SizedBox(width: 10), Expanded(child: _stat('${DataKespro.rujukanList.length}', 'Dirujuk', Colors.orange))]),
        const SizedBox(height: 20),
        const Text('Menu Cepat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _menu(context, 'Tambah Pasien Baru', Icons.person_add, const PasienFormScreen()),
        _menu(context, 'Form ANC + Skrining', Icons.monitor_heart, const AncFormScreen()),
        _menu(context, 'Buat Surat Rujukan', Icons.local_hospital, const RujukanFormScreen()),
        _menu(context, 'Laporan Bulanan', Icons.bar_chart, const LaporanScreen()),
      ])));
  }
  Widget _stat(String angka, String label, Color c) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(0.3))), child: Column(children: [Text(angka, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: c)), Text(label, style: TextStyle(color: c))]));
  Widget _menu(BuildContext ctx, String t, IconData i, Widget p) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: Colors.pink.shade50, child: Icon(i, color: Colors.pink)), title: Text(t), trailing: const Icon(Icons.arrow_forward_ios, size: 14), onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => p))));
}

// ===== LIST PASIEN =====
class PasienListScreen extends StatefulWidget {
  const PasienListScreen({super.key});
  @override
  State<PasienListScreen> createState() => _PasienListState();
}
class _PasienListState extends State<PasienListScreen> {
  String cari = '';
  @override
  Widget build(BuildContext context) {
    var list = DataKespro.pasienList.where((p) => p['nama']!.toLowerCase().contains(cari.toLowerCase())).toList();
    return Scaffold(appBar: AppBar(title: const Text('Daftar Pasien'), backgroundColor: Colors.pink, foregroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.pink, foregroundColor: Colors.white, onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const PasienFormScreen())); setState(() {}); }, child: const Icon(Icons.add)),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: TextField(onChanged: (v) => setState(() => cari = v), decoration: const InputDecoration(hintText: 'Cari nama pasien...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))))),
        Expanded(child: list.isEmpty ? const Center(child: Text('Belum ada pasien')) : ListView.builder(itemCount: list.length, itemBuilder: (c, i) {
          var p = list[i];
          return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), child: ListTile(leading: CircleAvatar(backgroundColor: Colors.pink.shade100, child: Text(p['nama']![0], style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold))), title: Text(p['nama']!), subtitle: Text('NIK: ${p['nik']} • ${p['kategori']} • Umur ${p['umur']}'), trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () { setState(() => DataKespro.pasienList.remove(p)); }), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PasienDetailScreen(pasien: p)))));
        })),
      ]));
  }
}

class PasienDetailScreen extends StatelessWidget {
  final Map<String, String> pasien; const PasienDetailScreen({super.key, required this.pasien});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(pasien['nama']!)), body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(child: kesproIcon(size: 80)), const SizedBox(height: 20),
      _row('Nama', pasien['nama']!), _row('NIK', pasien['nik']!), _row('Kategori', pasien['kategori']!), _row('Umur', '${pasien['umur']} tahun'), _row('Telp / WA', pasien['telp']!),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AncFormScreen())), child: const Text('BUAT KUNJUNGAN ANC'))),
    ])));
  }
  Widget _row(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [SizedBox(width: 100, child: Text(l, style: const TextStyle(color: Colors.grey))), Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.bold)))]));
}

// ===== FORM PASIEN =====
class PasienFormScreen extends StatefulWidget {
  const PasienFormScreen({super.key});
  @override
  State<PasienFormScreen> createState() => _PasienFormState();
}
class _PasienFormState extends State<PasienFormScreen> {
  final nikC = TextEditingController(); final namaC = TextEditingController(); final umurC = TextEditingController(); final telpC = TextEditingController();
  String kategori = 'Hamil';
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Tambah Pasien')), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
      TextField(controller: nikC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'NIK (16 digit)', border: OutlineInputBorder())), const SizedBox(height: 12),
      TextField(controller: namaC, decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder())), const SizedBox(height: 12),
      TextField(controller: umurC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Umur', border: OutlineInputBorder())), const SizedBox(height: 12),
      TextField(controller: telpC, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Telp / WA', border: OutlineInputBorder())), const SizedBox(height: 12),
      DropdownButtonFormField<String>(value: kategori, decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()), items: ['Remaja','Pranikah','Prakonsepsi','Hamil'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => kategori = v!)),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white), onPressed: () {
        if (namaC.text.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama wajib diisi!'))); return; }
        DataKespro.pasienList.add({'nama': namaC.text, 'nik': nikC.text, 'kategori': kategori, 'umur': umurC.text, 'telp': telpC.text});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pasien Berhasil Disimpan!')));
        Navigator.pop(context);
      }, child: const Text('SIMPAN PASIEN'))),
    ])));
  }
}

// ===== FORM ANC =====
class AncFormScreen extends StatefulWidget {
  const AncFormScreen({super.key});
  @override
  State<AncFormScreen> createState() => _AncState();
}
class _AncState extends State<AncFormScreen> {
  final hbC = TextEditingController(); final lilaC = TextEditingController(); final bbC = TextEditingController(); final tdC = TextEditingController();
  String hasil = 'Isi data, lalu klik Cek Risiko';
  bool isTinggi = false;
  void cek() {
    double hb = double.tryParse(hbC.text) ?? 12; double lila = double.tryParse(lilaC.text) ?? 24;
    int skor = 0; String catatan = '';
    if (hb < 11) { skor += 4; catatan += 'Anemia (Hb $hb). '; }
    if (lila < 23.5) { skor += 4; catatan += 'KEK (LILA $lila). '; }
    if (tdC.text.contains('140') || tdC.text.contains('150')) { skor += 8; catatan += 'Hipertensi. '; }
    setState(() {
      isTinggi = skor >= 6;
      hasil = isTinggi ? 'RISIKO TINGGI (Skor $skor)\n$catatan\nWAJIB RUJUK!' : 'RISIKO RENDAH (Skor $skor)\n$catatan\nANC RUTIN K1-K6';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Form ANC + Skrining'), backgroundColor: Colors.pink, foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        TextField(controller: bbC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'BB (kg)', border: OutlineInputBorder())), const SizedBox(height: 12),
        TextField(controller: tdC, decoration: const InputDecoration(labelText: 'TD (contoh: 120/80)', border: OutlineInputBorder())), const SizedBox(height: 12),
        TextField(controller: hbC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Hb (contoh: 10.5)', border: OutlineInputBorder())), const SizedBox(height: 12),
        TextField(controller: lilaC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'LILA (contoh: 22)', border: OutlineInputBorder())), const SizedBox(height: 20),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white), onPressed: cek, child: const Text('CEK RISIKO OTOMATIS'))),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(16), width: double.infinity, decoration: BoxDecoration(color: isTinggi ? Colors.red.shade100 : Colors.green.shade100, borderRadius: BorderRadius.circular(12)), child: Text(hasil, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white), onPressed: () {
          DataKespro.ancList.add({'hb': hbC.text, 'lila': lilaC.text, 'hasil': hasil, 'tanggal': DateTime.now().toString().substring(0, 10)});
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kunjungan ANC Tersimpan!')));
          Navigator.pop(context);
        }, child: const Text('SIMPAN KUNJUNGAN ANC'))),
        if (isTinggi) Padding(padding: const EdgeInsets.only(top: 12), child: SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RujukanFormScreen())), child: const Text('BUAT SURAT RUJUKAN SEKARANG')))),
      ])));
  }
}

// ===== RUJUKAN =====
class RujukanFormScreen extends StatelessWidget {
  const RujukanFormScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final rsC = TextEditingController(); final diagC = TextEditingController();
    return Scaffold(appBar: AppBar(title: const Text('Surat Rujukan'), backgroundColor: Colors.red, foregroundColor: Colors.white),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        TextField(controller: rsC, decoration: const InputDecoration(labelText: 'RS Tujuan', border: OutlineInputBorder())), const SizedBox(height: 12),
        TextField(controller: diagC, maxLines: 3, decoration: const InputDecoration(labelText: 'Diagnosis / Alasan Rujuk', border: OutlineInputBorder())), const SizedBox(height: 20),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () {
          DataKespro.rujukanList.add({'rs': rsC.text, 'diag': diagC.text, 'tanggal': DateTime.now().toString().substring(0, 10)});
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rujukan Terkirim & Tersimpan!')));
          Navigator.pop(context);
        }, child: const Text('KIRIM RUJUKAN + WA'))),
      ])));
  }
}

class RujukanListScreen extends StatelessWidget {
  const RujukanListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Daftar Rujukan'), backgroundColor: Colors.red, foregroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.red, foregroundColor: Colors.white, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RujukanFormScreen())), child: const Icon(Icons.add)),
      body: DataKespro.rujukanList.isEmpty ? const Center(child: Text('Belum ada rujukan')) : ListView.builder(itemCount: DataKespro.rujukanList.length, itemBuilder: (c, i) { var r = DataKespro.rujukanList[i]; return Card(margin: const EdgeInsets.all(8), child: ListTile(leading: const CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.local_hospital, color: Colors.white)), title: Text(r['rs'] ?? 'RS'), subtitle: Text('${r['diag']} • ${r['tanggal']}'))); }));
  }
}

// ===== LAPORAN =====
class LaporanScreen extends StatelessWidget {
  const LaporanScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Laporan Bulanan')),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Laporan November 2026', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text('• Total Pasien: ${DataKespro.pasienList.length}'),
        Text('• Kunjungan ANC: ${DataKespro.ancList.length}'),
        Text('• Risiko Tinggi: ${DataKespro.ancList.where((e) => e['hasil']!.contains('TINGGI')).length}'),
        Text('• Dirujuk: ${DataKespro.rujukanList.length}'),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur Export PDF akan aktif di Versi 3'))), child: const Text('EXPORT PDF / EXCEL'))),
      ])));
  }
}
