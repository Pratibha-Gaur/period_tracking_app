import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    pass.dispose();
    super.dispose();
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
              "Create Account",
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
                field("Full Name", Icons.person, name),
                SizedBox(height: 15),
                field("Email", Icons.email, email),
                SizedBox(height: 15),
                field("Password", Icons.lock, pass, obscure: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50)),
                  child: const Text("Register"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}