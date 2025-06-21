import 'package:flutter/material.dart';
import '../models/izin_model.dart';

class IzinCard extends StatelessWidget {
  final Izin izin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const IzinCard({
    super.key,
    required this.izin,
    required this.onEdit,
    required this.onDelete,
    required this.onApprove,
    required this.onReject,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Sedang Izin':
        return Colors.green;
      case 'Sudah Kembali':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 3,
      child: ListTile(
        title: Text(izin.nama, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kamar: ${izin.kamar}'),
            Text('Tujuan: ${izin.tujuan}'),
            Text('Tanggal: ${izin.tanggal}'),
            Text(
              'Status: ${izin.status}',
              style: TextStyle(
                color: _getStatusColor(izin.status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.grey),
              onPressed: onDelete,
            ),
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: onApprove,
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: onReject,
            ),
          ],
        ),
      ),
    );
  }
}
