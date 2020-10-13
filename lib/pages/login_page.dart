import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_crud_sqflite/pages/home_page.dart';
import 'package:tugas_crud_sqflite/pages/register_page.dart';
import 'package:tugas_crud_sqflite/utils/db_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum statusLogin { guest, login }

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int isLogin = 0;
  bool isLoading = false;
  DatabaseHelper db = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void check() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      isLoading = true;
      setState(() {});
      submitDataLogin();
    }
  }

  void submitDataLogin() async {
    var result = await db.checkLogin(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      saveDataPref(
        username: result.username,
        email: result.email,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Email atau password salah'),
        ),
      );
    }
  }

  void getDataPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isLogin = pref.getInt('login');
    });
  }

  void saveDataPref({String username, String email}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('login', 1);
    pref.setString('username', username);
    pref.setString('email', email);
  }

  @override
  void initState() {
    super.initState();
    getDataPref();
  }

  @override
  Widget build(BuildContext context) {
    return isLogin == 1
        ? HomePage()
        : Scaffold(
            key: _scaffoldKey,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: FlutterLogo(
                            size: 150,
                            style: FlutterLogoStyle.stacked,
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    validator: (e) {
                                      return e.toLowerCase().trim().isEmpty
                                          ? 'please insert email'
                                          : null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(
                                        Icons.email,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    validator: (e) {
                                      return e.toLowerCase().trim().isEmpty
                                          ? 'please insert password'
                                          : null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(
                                        Icons.lock,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  RaisedButton(
                                    onPressed: check,
                                    child: Text('Sign In'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have account ? ",
                              style: TextStyle(
                                letterSpacing: 2,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  letterSpacing: 2,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
