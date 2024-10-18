import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aplikasi_manajemen_kesehatan/model/kesehatan_mental.dart';
import 'package:aplikasi_manajemen_kesehatan/bloc/kesehatan_mental_bloc.dart';
import 'package:aplikasi_manajemen_kesehatan/ui/kesehatan_mental_page.dart';
import 'package:aplikasi_manajemen_kesehatan/widget/warning_dialog.dart';

class KesehatanMentalForm extends StatefulWidget {
  final KesehatanMental? dataKesehatanMental;

  const KesehatanMentalForm({Key? key, this.dataKesehatanMental})
      : super(key: key);

  @override
  _KesehatanMentalFormState createState() => _KesehatanMentalFormState();
}

class _KesehatanMentalFormState extends State<KesehatanMentalForm> {
  final _formKey = GlobalKey<FormState>();
  final _mentalStateController = TextEditingController();
  final _therapySessionsController = TextEditingController();
  final _medicationController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data jika ada
    if (widget.dataKesehatanMental != null) {
      _mentalStateController.text =
          widget.dataKesehatanMental!.mentalState ?? "";
      _therapySessionsController.text =
          widget.dataKesehatanMental!.therapySessions?.toString() ?? "";
      _medicationController.text = widget.dataKesehatanMental!.medication ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.dataKesehatanMental != null
              ? "UBAH DATA KESEHATAN"
              : "TAMBAH DATA KESEHATAN",
          style: const TextStyle(fontFamily: 'Georgia', color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Kondisi Mental", _mentalStateController,
                  "Kondisi Mental harus diisi"),
              _buildTextField("Sesi Terapi", _therapySessionsController,
                  "Jumlah sesi terapi harus diisi",
                  keyboardType: TextInputType.number),
              _buildTextField(
                  "Obat", _medicationController, "Obat harus diisi"),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              if (widget.dataKesehatanMental != null) ...[
                const SizedBox(height: 16),
                _buildDeleteButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membangun field input
  Widget _buildTextField(
      String label, TextEditingController controller, String validatorMessage,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontFamily: 'Georgia'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
        ),
        validator: (value) => value!.isEmpty ? validatorMessage : null,
      ),
    );
  }

  // Widget untuk tombol submit
  Widget _buildSubmitButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
        textStyle: const TextStyle(fontFamily: 'Georgia'),
      ),
      child: Text(widget.dataKesehatanMental != null ? "UBAH" : "SIMPAN"),
      onPressed: _onSubmit,
    );
  }

  // Widget untuk tombol hapus
  Widget _buildDeleteButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        textStyle: const TextStyle(fontFamily: 'Georgia'),
      ),
      child: const Text("HAPUS DATA"),
      onPressed: _onDelete,
    );
  }

  // Fungsi untuk menangani submit
  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final data = KesehatanMental(
        id: widget.dataKesehatanMental?.id,
        mentalState: _mentalStateController.text,
        therapySessions: int.tryParse(_therapySessionsController.text) ?? 0,
        medication: _medicationController.text,
      );

      setState(() => _isLoading = true);
      widget.dataKesehatanMental != null ? _ubah(data) : _simpan(data);
    }
  }

  // Fungsi untuk menyimpan data
  Future<void> _simpan(KesehatanMental data) async {
    try {
      final success = await KesehatanMentalBloc.addDataKesehatanMental(
          kesehatanMental: data);
      if (success) {
        _navigateToHome();
      } else {
        throw Exception("Gagal menyimpan data");
      }
    } catch (_) {
      _showErrorDialog("Simpan gagal, silahkan coba lagi");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Fungsi untuk mengubah data
  Future<void> _ubah(KesehatanMental data) async {
    try {
      final success = await KesehatanMentalBloc.updateDataKesehatanMental(
          kesehatanMental: data);
      if (success) {
        _navigateToHome();
      } else {
        throw Exception("Gagal mengubah data");
      }
    } catch (_) {
      _showErrorDialog("Ubah gagal, silahkan coba lagi");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Fungsi untuk menangani penghapusan data
  void _onDelete() async {
    if (widget.dataKesehatanMental?.id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Batal")),
            TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Hapus")),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        setState(() => _isLoading = true);
        final success = await KesehatanMentalBloc.deleteDataKesehatanMental(
            id: widget.dataKesehatanMental!.id!);
        if (success) {
          _navigateToHome();
        } else {
          throw Exception("Gagal menghapus data");
        }
      } catch (e) {
        _showErrorDialog("Hapus gagal, silahkan coba lagi: ${e.toString()}");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // Navigasi ke halaman utama
  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const KesehatanMentalPage()),
      (route) => false,
    );
  }

  // Menampilkan dialog kesalahan
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => WarningDialog(description: message),
    );
  }
}
