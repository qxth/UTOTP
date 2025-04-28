import 'package:flutter/material.dart';

class CuentaTarjeta extends StatelessWidget {
  const CuentaTarjeta({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo GitHub
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/25/25231.png'),
              ),
              const SizedBox(width: 20),
              // Información
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('GITHUB', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 5),
                  Text('Cuenta:', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text('correo@hotmail.com', style: TextStyle(fontSize: 14, color: Colors.black87)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
