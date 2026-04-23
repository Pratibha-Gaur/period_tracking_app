import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final pass = TextEditingController();

  bool isHover = false;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  Widget field(String hint, IconData icon, TextEditingController c,
      {bool obscure = false}) {
    return TextField(
      controller: c,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.pink),
        filled: true,
        fillColor: Colors.pink.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(20),
            child: Text(
              "Welcome Back",
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                field("Email", Icons.email, email),
                SizedBox(height: 15),
                field("Password", Icons.lock, pass, obscure: true),
                SizedBox(height: 20),

                /// Hover Button
                MouseRegion(
                  onEnter: (_) => setState(() => isHover = true),
                  onExit: (_) => setState(() => isHover = false),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isHover ? Colors.pink.shade700 : Colors.pink,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: login,
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: Text("Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterPage()),
                  ),
                  child: Text("Create Account",
                      style: TextStyle(color: Colors.pink)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}