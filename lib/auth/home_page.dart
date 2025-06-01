import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiftpick_spa/auth/login_page.dart';
import 'package:swiftpick_spa/components/mybutton.dart';
import 'package:swiftpick_spa/pages/hizmet_page.dart';
import 'package:swiftpick_spa/pages/masor_page.dart';

class HomePage extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;
   HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SwiftPick SPA'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment:MainAxisAlignment.start,
         children : [
          Padding(padding: const EdgeInsets.all(10.0),
          child: Container(decoration:BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withAlpha(100), width: 3),
          ),
          padding: const EdgeInsets.all(10),
          child: const Icon(
            Icons.person,
            size: 30,
            color: Colors.black87,
          )),
          ),
          Text(
            currentUser?.email ?? 'No user logged in',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
         ],),
          const SizedBox(
                  height: 30,
                ),
          Container(padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white),
          child: GridView.count(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 40,
            mainAxisSpacing: 30,
            children: [
              MyButton(
                title: 'Masörler',
                icondata: Icons.people,
                onTap: () {
                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MasorPage()),
                            );
                },
              ),
              MyButton(
                title: 'Hizmetler',
                icondata: Icons.bed,
                onTap: () {
                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HizmetPage()),
                            );
                },
              ),
              MyButton(
                title: 'Randevular',
                icondata: Icons.calendar_month,
                onTap: () {
                  // Bildirimler sayfasına yönlendirme
                },
              ),
              MyButton(
                title: 'Çıkış',
                icondata: Icons.logout,
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  //Navigator.pop(context); // Giriş sayfasına geri döner
                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                },
              ),
            ],
          ),
          ),
      ]),
    );
  }
}