import 'package:flutter/material.dart';
import '../models/izin_model.dart';
import '../database/izin_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _namaCtrl = TextEditingController();
  final _tujuanCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  String _selectedKamar = 'M.1';
  String _selectedWaktu = 'Pagi';
  String _searchKeyword = '';
  DateTime _selectedDate = DateTime.now();

  List<Izin> daftarIzin = [];

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    final data = await IzinDatabase.getAllIzin();
    setState(() {
      daftarIzin =
          data
              .where(
                (izin) =>
                    izin.nama.toLowerCase().contains(
                      _searchKeyword.toLowerCase(),
                    ) ||
                    izin.tujuan.toLowerCase().contains(
                      _searchKeyword.toLowerCase(),
                    ),
              )
              .toList();
    });
  }

  Future<void> _tambahIzin() async {
    final izin = Izin(
      nama: _namaCtrl.text,
      kamar: _selectedKamar,
      tujuan: _tujuanCtrl.text,
      tanggal:
          '${_selectedDate.toLocal()}'.split(' ')[0] + ' ($_selectedWaktu)',
      status: 'Pending',
    );
    await IzinDatabase.insertIzin(izin);
    _resetForm();
    _muatData();
  }

  Future<void> _editIzin(int id, Izin izin) async {
    await IzinDatabase.updateIzin(id, izin);
    _muatData();
  }

  Future<void> _hapusIzin(int id) async {
    await IzinDatabase.deleteIzin(id);
    _muatData();
  }

  void _resetForm() {
    _namaCtrl.clear();
    _selectedKamar = 'M.1';
    _tujuanCtrl.clear();
    _selectedDate = DateTime.now();
    _selectedWaktu = 'Pagi';
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Widget _buildInputForm({bool isDialog = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: isDialog ? MainAxisSize.min : MainAxisSize.max,
        children: [
          TextField(
            controller: _namaCtrl,
            decoration: InputDecoration(
              labelText: 'Nama',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          DropdownButtonFormField<String>(
            value: _selectedKamar,
            decoration: InputDecoration(
              labelText: 'Kamar',
              prefixIcon: Icon(Icons.home),
            ),
            items:
                List.generate(12, (i) => 'M.${i + 1}')
                    .map(
                      (kamar) =>
                          DropdownMenuItem(value: kamar, child: Text(kamar)),
                    )
                    .toList(),
            onChanged: (val) => setState(() => _selectedKamar = val!),
          ),
          TextField(
            controller: _tujuanCtrl,
            decoration: InputDecoration(
              labelText: 'Tujuan',
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Tanggal',
              prefixIcon: Icon(Icons.date_range),
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _pilihTanggal(context),
              ),
            ),
            controller: TextEditingController(
              text: '${_selectedDate.toLocal()}'.split(' ')[0],
            ),
          ),
          DropdownButtonFormField<String>(
            value: _selectedWaktu,
            decoration: InputDecoration(
              labelText: 'Waktu',
              prefixIcon: Icon(Icons.access_time),
            ),
            items:
                ['Pagi', 'Siang', 'Sore', 'Malam']
                    .map(
                      (waktu) =>
                          DropdownMenuItem(value: waktu, child: Text(waktu)),
                    )
                    .toList(),
            onChanged: (val) => setState(() => _selectedWaktu = val!),
          ),
          if (!isDialog) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text('Simpan Izin'),
                    onPressed: _tambahIzin,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      labelText: 'Pencarian',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() => _searchKeyword = val);
                      _muatData();
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIzinCard(Izin izin) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  izin.nama,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text('Kamar: ${izin.kamar}'),
            Text('Tujuan: ${izin.tujuan}'),
            Text('Tanggal: ${izin.tanggal}'),
            Text(
              'Status: ${izin.status}',
              style: TextStyle(
                color:
                    izin.status == 'Pending'
                        ? Colors.orange
                        : izin.status == 'Sedang Izin'
                        ? Colors.green
                        : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    _namaCtrl.text = izin.nama;
                    _selectedKamar = izin.kamar;
                    _tujuanCtrl.text = izin.tujuan;
                    _selectedDate =
                        DateTime.tryParse(izin.tanggal.split(' ')[0]) ??
                        DateTime.now();
                    _selectedWaktu =
                        izin.tanggal.contains('Pagi')
                            ? 'Pagi'
                            : izin.tanggal.contains('Siang')
                            ? 'Siang'
                            : izin.tanggal.contains('Sore')
                            ? 'Sore'
                            : 'Malam';

                    await showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: Text('Edit Izin'),
                            content: SingleChildScrollView(
                              child: _buildInputForm(isDialog: true),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Simpan'),
                                onPressed: () async {
                                  final updated = Izin(
                                    id: izin.id,
                                    nama: _namaCtrl.text,
                                    kamar: _selectedKamar,
                                    tujuan: _tujuanCtrl.text,
                                    tanggal:
                                        '${_selectedDate.toLocal()}'.split(
                                          ' ',
                                        )[0] +
                                        ' ($_selectedWaktu)',
                                    status: izin.status,
                                  );
                                  await _editIzin(izin.id!, updated);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _hapusIzin(izin.id!),
                ),
                IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  onPressed:
                      () => _editIzin(
                        izin.id!,
                        izin.copyWith(status: 'Sedang Izin'),
                      ),
                ),
                IconButton(
                  icon: Icon(Icons.home, color: Colors.blue),
                  onPressed:
                      () => _editIzin(
                        izin.id!,
                        izin.copyWith(status: 'Sudah Kembali'),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengajuan Izin Santri'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _muatData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _muatData,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            _buildInputForm(),
            const Divider(height: 20),
            ...daftarIzin.map(_buildIzinCard).toList(),
          ],
        ),
      ),
    );
  }
}

extension on Izin {
  Izin copyWith({
    String? nama,
    String? kamar,
    String? tujuan,
    String? tanggal,
    String? status,
  }) {
    return Izin(
      id: id,
      nama: nama ?? this.nama,
      kamar: kamar ?? this.kamar,
      tujuan: tujuan ?? this.tujuan,
      tanggal: tanggal ?? this.tanggal,
      status: status ?? this.status,
    );
  }
}
