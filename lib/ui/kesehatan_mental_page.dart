import 'package:aplikasi_manajemen_kesehatan/ui/kesehatan_mental_form.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_manajemen_kesehatan/bloc/logout_bloc.dart';
import 'package:aplikasi_manajemen_kesehatan/bloc/kesehatan_mental_bloc.dart';
import 'package:aplikasi_manajemen_kesehatan/model/kesehatan_mental.dart';
import 'package:aplikasi_manajemen_kesehatan/ui/login_page.dart';

class KesehatanMentalPage extends StatefulWidget {
  const KesehatanMentalPage({Key? key}) : super(key: key);

  @override
  _KesehatanMentalPageState createState() => _KesehatanMentalPageState();
}

class _KesehatanMentalPageState extends State<KesehatanMentalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'DATA KESEHATAN MENTAL',
          style: TextStyle(fontFamily: 'Georgia', color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KesehatanMentalForm(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      drawer: Drawer(
        backgroundColor: Colors.grey[850],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Manajemen Kesehatan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aplikasi Kesehatan Mental',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  color: Colors.white,
                ),
              ),
              trailing: const Icon(Icons.logout, color: Colors.white),
              onTap: () async {
                await LogoutBloc.logout().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: KesehatanMentalBloc.getDataKesehatanMental(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListKesehatanMental(list: snapshot.data)
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ListKesehatanMental extends StatelessWidget {
  final List? list;
  const ListKesehatanMental({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list?.length ?? 0,
      itemBuilder: (context, i) {
        return ItemKesehatanMental(data: list![i]);
      },
    );
  }
}

class ItemKesehatanMental extends StatelessWidget {
  final KesehatanMental data;
  const ItemKesehatanMental({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KesehatanMentalForm(
              dataKesehatanMental: data,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.grey[800],
        child: ListTile(
          title: Text(
            data.mentalState ?? "Tidak diketahui",
            style: const TextStyle(fontFamily: 'Georgia', color: Colors.white),
          ),
          subtitle: Text(
            "Sesi Terapi: ${data.therapySessions}",
            style:
                const TextStyle(fontFamily: 'Georgia', color: Colors.white70),
          ),
          trailing: Text(
            data.medication ?? "Tanpa obat",
            style: const TextStyle(fontFamily: 'Georgia', color: Colors.white),
          ),
        ),
      ),
    );
  }
}
