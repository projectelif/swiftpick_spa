import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'auth_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giriş Yap")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, decoration: InputDecoration(labelText: "Şifre"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final user = await _auth.signIn(emailCtrl.text, passCtrl.text);
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Giriş başarılı")));
                    // İleriye yönlendirme yapılabilir
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
                }
              },
              child: Text("Giriş Yap"),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPage())),
              child: Text("Hesabınız yok mu? Kayıt olun"),
            )
          ],
        ),
      ),
    );
  }
}
