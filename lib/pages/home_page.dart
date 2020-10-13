import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_crud_sqflite/model/model_mahasiswa.dart';
import 'package:tugas_crud_sqflite/pages/detail_mahasiswa.dart';
import 'package:tugas_crud_sqflite/pages/form_mahasiswa.dart';
import 'package:tugas_crud_sqflite/pages/login_page.dart';
import 'package:tugas_crud_sqflite/utils/db_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email = '';
  String username = '';
  List<ModelMahasiswa> listMahasiswa = [];
  DatabaseHelper db = DatabaseHelper();

  Future<void> _getAllMahasiswa() async {
    var list = await db.getAllMahasiswa();
    setState(() {
      listMahasiswa.clear();
      list.forEach((element) {
        listMahasiswa.add(ModelMahasiswa.fromMap(element));
      });
      print(list);
    });
  }

  Future<void> _deleteMahasiswa(ModelMahasiswa mahasiswa, int position) async {
    await db.deleteMahasiswa(mahasiswa.id);

    setState(() {
      listMahasiswa.removeAt(position);
    });
  }

  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormMahasiswa(),
      ),
    );

    if (result == 'save') {
      await _getAllMahasiswa();
    }
  }

  Future<void> _openFormEdit(ModelMahasiswa mahasiswa) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormMahasiswa(mahasiswa: mahasiswa),
      ),
    );

    if (result == 'update') {
      await _getAllMahasiswa();
    }
  }

  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  void getDataPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      username = pref.getString('username');
      email = pref.getString('email');
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllMahasiswa();
    getDataPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Flutter CRUD SQLite'),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(minRadius: 30),
                  Text("$username"),
                  Text("$email"),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('LOGOUT'),
              onTap: logout,
            ),
            Divider()
          ],
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: listMahasiswa.length,
          itemBuilder: (context, index) {
            ModelMahasiswa mahasiswa = listMahasiswa[index];

            return Column(
              children: [
                ListTile(
                  onTap: () {
                    // OPEN FORM EDIT
                    _openFormEdit(mahasiswa);
                  },
                  title: Text("${mahasiswa.firstName} ${mahasiswa.lastName}"),
                  subtitle: Text("${mahasiswa.jurusan} | ${mahasiswa.email}"),
                  leading: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      // DETAIL PAGE
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            mahasiswa: mahasiswa,
                          ),
                        ),
                      );
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      AlertDialog hapus = AlertDialog(
                        title: Text('Informations'),
                        content: Container(
                          height: 100,
                          child: Column(
                            children: [
                              Text(
                                "Apakah yakin ingin menghapus data ${mahasiswa.email} ?",
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              // DELETE
                              _deleteMahasiswa(mahasiswa, index);
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                      showDialog(context: context, child: hapus);
                    },
                  ),
                ),
                Divider(thickness: 2)
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          _openFormCreate();
        },
      ),
    );
  }
}
