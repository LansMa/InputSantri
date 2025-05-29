class Izin {
  int? id;
  String nama;
  String kamar;
  String tujuan;
  String tanggal;
  String status;

  Izin({
    this.id,
    required this.nama,
    required this.kamar,
    required this.tujuan,
    required this.tanggal,
    required this.status,
  });

  factory Izin.fromMap(Map<String, dynamic> json) => Izin(
    id: json['id'],
    nama: json['nama'],
    kamar: json['kamar'],
    tujuan: json['tujuan'],
    tanggal: json['tanggal'],
    status: json['status'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nama': nama,
    'kamar': kamar,
    'tujuan': tujuan,
    'tanggal': tanggal,
    'status': status,
  };
}
