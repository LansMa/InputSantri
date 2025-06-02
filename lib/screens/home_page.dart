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
  String _selectedKamar = 'M.1';
  final _tujuanCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedWaktu = 'Pagi';

  List<Izin> daftarIzin = [];

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    final data = await IzinDatabase.getAllIzin();
    setState(() {
      daftarIzin = data;
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
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text('Simpan Izin'),
              onPressed: _tambahIzin,
            ),
          ],
        ],
      ),
    );
  }

