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
