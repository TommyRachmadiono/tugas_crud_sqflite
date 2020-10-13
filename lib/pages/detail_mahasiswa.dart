import 'package:flutter/material.dart';
import 'package:tugas_crud_sqflite/model/model_mahasiswa.dart';

class DetailPage extends StatelessWidget {
  final ModelMahasiswa mahasiswa;
  DetailPage({this.mahasiswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Detail Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${mahasiswa.firstName} ${mahasiswa.lastName}"),
            Text("${mahasiswa.jurusan}"),
            Text("${mahasiswa.mobileNumber}"),
            Text("${mahasiswa.email}"),
          ],
        ),
      ),
    );
  }
}
