import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final String title;
  final IconData icondata;
  final Function()? onTap;

  const MyButton({super.key, required this.title, required this.icondata, required this.onTap});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withAlpha(100), width: 3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration:
                  const BoxDecoration(shape: BoxShape.circle),
              child: Icon (
                icondata,
                color: Colors.black87,
                size: 50,
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )));
  }
}