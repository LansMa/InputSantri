import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/izin_model.dart';

class IzinDatabase {
  static final _client = Supabase.instance.client;

  static Future<void> insertIzin(Izin izin) async {
    await _client.from('izin').insert(izin.toInsertMap());
  }

  static Future<List<Izin>> getAllIzin() async {
    final response = await _client.from('izin').select();
    final List<dynamic> rawList = response;
    return rawList.map((e) => Izin.fromMap(e as Map<String, dynamic>)).toList();
  }

  static Future<void> updateIzin(int id, Izin izin) async {
    await _client.from('izin').update(izin.toMap()).eq('id', id);
  }

  static Future<void> deleteIzin(int id) async {
    await _client.from('izin').delete().eq('id', id);
  }
}
