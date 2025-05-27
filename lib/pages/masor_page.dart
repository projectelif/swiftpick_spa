import 'package:flutter/material.dart';

class MasorPage extends StatelessWidget {
  const MasorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Center(
        child: Column(
          children: [

          const SizedBox(height: 10),
          Flexible(
          child : Text( 'Masörler sayfası henüz tamamlanmadı.',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),),
          ),
        ]),
      ),
    );
  }
}

AppBar appBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.background,
    title: const Text(
      'Masörler',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    leading: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: const Icon(Icons.arrow_left,
        size: 35,),
      ),
    ),
  );
}
