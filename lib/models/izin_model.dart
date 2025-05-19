class Izin {
  int? id;
  final String nama;
  final String kelas;
  final String tujuan;
  final String tanggal;
  String status; // 'Pending', 'Diterima', 'Ditolak'

  Izin({
    this.id,
    required this.nama,
    required this.kelas,
    required this.tujuan,
    required this.tanggal,
    this.status = 'Pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'kelas': kelas,
      'tujuan': tujuan,
      'tanggal': tanggal,
      'status': status,
    };
  }

  factory Izin.fromMap(Map<String, dynamic> map) {
    return Izin(
      id: map['id'],
      nama: map['nama'],
      kelas: map['kelas'],
      tujuan: map['tujuan'],
      tanggal: map['tanggal'],
      status: map['status'],
    );
  }
}
