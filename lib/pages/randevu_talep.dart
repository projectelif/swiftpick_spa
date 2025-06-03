import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RandevuTalepPage extends StatefulWidget {
  const RandevuTalepPage({super.key});

  @override
  _RandevuTalepPageState createState() => _RandevuTalepPageState();
}

class _RandevuTalepPageState extends State<RandevuTalepPage> {
  String? _selectedMassage;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedTherapistGender;

  final List<String> _massageTypes = [
    'Bali Masajı',
    'Medikal Masaj',
    'Thai Masajı',
    'Refleksoloji',
    'Sıcak Taş Masajı',
  ];

  final List<String> _therapistGenders = [
    'Erkek',
    'Kadın',
    'Farketmez',
  ];

// Firestore ve Auth instance'ları
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitAppointmentRequest() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen giriş yapın!')),
      );
      return;
    }

    try {
      await _firestore.collection('appointments').add({
        'userId': user.uid, // Randevuyu talep eden kullanıcının UID'si
        'massageType': _selectedMassage,
        'appointmentDate': _selectedDate,
        'appointmentTime': _selectedTime.format(context), // Saati string olarak kaydetmek daha kolay olabilir
        'therapistGender': _selectedTherapistGender,
        'timestamp': FieldValue.serverTimestamp(), // Randevu talep zamanı
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Randevu Talebiniz Alındı ve Kaydedildi!')),
      );
    } catch (e) {
      print('Randevu kaydetme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Randevu kaydedilirken bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevu Talep'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Masaj Seçimi
            const Text(
              'Masaj Seçin',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _selectedMassage,
              hint: const Text('Bir masaj tipi seçin'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMassage = newValue;
                });
              },
              items: _massageTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
            const SizedBox(height: 20.0),

            // Randevu Tarihi
            const Text(
              'Randevu Tarihi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Randevu Saati
            const Text(
              'Randevu Saati',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: _selectedTime.format(context),
                    suffixIcon: const Icon(Icons.access_time),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Masör Cinsiyeti
            const Text(
              'Masör Cinsiyeti',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _selectedTherapistGender,
              hint: const Text('Cinsiyet seçin'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTherapistGender = newValue;
                });
              },
              items: _therapistGenders.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
            const SizedBox(height: 60.0),

            // Randevu Talep Et Butonu
            // Randevu Talep Et Butonu
            SizedBox( // Butonun genişliğini ayarlamak için SizedBox ile sarıldı
              width: double.infinity, // Tam genişlik
              child: ElevatedButton(
                onPressed: _submitAppointmentRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Arka plan turuncu
                  foregroundColor: Colors.black, // Yazı rengi siyah
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder( // Kenar stilini ayarla
                    borderRadius: BorderRadius.circular(5.0), // Combobox'larla aynı kenar yuvarlama
                    side: const BorderSide(color: Colors.grey), // İsteğe bağlı olarak kenarlık rengi
                  ),
                ),
                child: const Text(
                  'Randevu Talep Et',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}