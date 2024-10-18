import 'package:flutter/material.dart';
import 'package:aplikasi_manajemen_kesehatan/bloc/kesehatan_mental_bloc.dart';
import 'package:aplikasi_manajemen_kesehatan/model/kesehatan_mental.dart';
import 'package:aplikasi_manajemen_kesehatan/ui/kesehatan_mental_form.dart';
import 'package:aplikasi_manajemen_kesehatan/ui/kesehatan_mental_page.dart';
import 'package:aplikasi_manajemen_kesehatan/widget/warning_dialog.dart';

class KesehatanMentalDetail extends StatefulWidget {
  final KesehatanMental? data;

  const KesehatanMentalDetail({Key? key, this.data}) : super(key: key);

  @override
  _KesehatanMentalDetailState createState() => _KesehatanMentalDetailState();
}

class _KesehatanMentalDetailState extends State<KesehatanMentalDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Detail Kesehatan Mental',
          style: TextStyle(fontFamily: 'Georgia'),
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailText("ID", widget.data?.id.toString() ?? "-"),
            const Divider(color: Colors.white),
            _buildDetailText("Kondisi Mental", widget.data?.mentalState ?? "-"),
            const Divider(color: Colors.white),
            _buildDetailText(
                "Sesi Terapi", widget.data?.therapySessions.toString() ?? "-"),
            const Divider(color: Colors.white),
            _buildDetailText("Obat", widget.data?.medication ?? "-"),
            const SizedBox(height: 20.0),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          fontSize: 18.0,
          fontFamily: 'Georgia',
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Tombol Edit
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 126, 113, 205),
          ),
          child: const Text(
            "EDIT",
            style: TextStyle(color: Colors.white, fontFamily: 'Courier New'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    KesehatanMentalForm(dataKesehatanMental: widget.data!),
              ),
            );
          },
        ),
        // Tombol Hapus
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 126, 113, 205),
          ),
          child: const Text(
            "DELETE",
            style: TextStyle(color: Colors.white, fontFamily: 'Courier New'),
          ),
          onPressed: () => _confirmHapus(),
        ),
      ],
    );
  }

  void _confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.grey[800],
      content: const Text(
        "Yakin ingin menghapus data ini?",
        style: TextStyle(fontFamily: 'Courier New', color: Colors.white),
      ),
      actions: [
        // Tombol Hapus
        OutlinedButton(
          child: const Text(
            "Ya",
            style: TextStyle(
              color: Color.fromARGB(255, 232, 125, 227),
              fontFamily: 'Courier New',
            ),
          ),
          onPressed: () {
            final id = widget.data?.id;
            if (id != null) {
              KesehatanMentalBloc.deleteDataKesehatanMental(id: id).then(
                (value) {
                  if (value) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const KesehatanMentalPage(),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => const WarningDialog(
                        description: "Hapus gagal, silahkan coba lagi",
                      ),
                    );
                  }
                },
                onError: (error) {
                  showDialog(
                    context: context,
                    builder: (context) => const WarningDialog(
                      description: "Hapus gagal, silahkan coba lagi",
                    ),
                  );
                },
              );
            } else {
              // Jika id null, tampilkan pesan error atau penanganan lain
              showDialog(
                context: context,
                builder: (context) => const WarningDialog(
                  description: "ID tidak ditemukan.",
                ),
              );
            }
          },
        ),
        // Tombol Batal
        OutlinedButton(
          child: const Text(
            "Batal",
            style: TextStyle(
              color: Color.fromARGB(255, 232, 125, 227),
              fontFamily: 'Courier New',
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
