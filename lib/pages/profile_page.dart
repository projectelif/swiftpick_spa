import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiftpick_spa/auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Varsayılan değerler veya veritabanından çekilecek bilgiler
  String _name = "";
  int _age = 0;
  String _gender = "BELİRTMEK İSTEMİYORUM";
  String _notes = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isEditing = false;
  final List<String> _genders = ['ERKEK', 'KADIN', 'BELİRTMEK İSTEMİYORUM'];

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Sayfa yüklendiğinde kullanıcı profilini çek
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Kullanıcı profilini Firestore'dan yükleme
  Future<void> _loadUserProfile() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      // Kullanıcı giriş yapmamışsa yapacak bir şey yok
      return;
    }

    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        // Belge varsa verileri yükle
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _name = data['name'] ?? '';
          _age = data['age'] ?? 0;
          _gender = data['gender'] ?? 'BELİRTMEK İSTEMİYORUM';
          _notes = data['notes'] ?? '';

          _nameController.text = _name;
          _ageController.text = _age == 0 ? '' : _age.toString(); // Yaş 0 ise boş göster
          _notesController.text = _notes;
        });
      } else {
        // Belge yoksa (yeni kullanıcı), varsayılan değerleri controller'lara ata
        _nameController.text = _name;
        _ageController.text = _age == 0 ? '' : _age.toString();
        _notesController.text = _notes;
        print('Kullanıcı için Firestore belgesi bulunamadı. Yeni oluşturulacak.');
      }
    } catch (e) {
      print('Profil yükleme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil yüklenirken bir hata oluştu: $e')),
      );
    }
  }

  // Kullanıcı profilini Firestore'a kaydetme/güncelleme
  Future<void> _saveUserProfile() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş yapmamış kullanıcı!')),
      );
      return;
    }

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'gender': _gender,
        'notes': _notesController.text,
        'lastUpdated': FieldValue.serverTimestamp(), // Son güncelleme zaman damgası
      }, SetOptions(merge: true)); // `merge: true` ile mevcut alanları koru, sadece verilenleri güncelle

      setState(() {
        _name = _nameController.text;
        _age = int.tryParse(_ageController.text) ?? 0;
        _notes = _notesController.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil Bilgileri Firestore\'a Kaydedildi!')),
      );
    } catch (e) {
      print('Profil kaydetme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil kaydedilirken bir hata oluştu: $e')),
      );
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Düzenleme modundan çıkıldığında, güncel verileri kaydet
        _saveUserProfile();
      }
    });
  }

  void _logout() async {
    try {
      await _auth.signOut();
      print('Kullanıcı çıkış yaptı!');
      // Çıkış sonrası giriş sayfasına yönlendirme
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Çıkış hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Çıkış yapılırken bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Sayfası'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit), // Düzenleme moduna göre ikon değişir
            onPressed: _toggleEditMode,
          ),
          IconButton(
            icon: const Icon(Icons.logout), // Çıkış butonu
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Ad Bilgisi
            const Text(
              'Ad:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _isEditing
                ? TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Adınızı girin',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                  )
                : Text(
                    _name.isNotEmpty ? _name : 'Henüz Ad Tanımlanmadı',
                    style: const TextStyle(fontSize: 18),
                  ),
            const SizedBox(height: 20.0),

            // Yaş Bilgisi
            const Text(
              'Yaş:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _isEditing
                ? TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number, // Sadece sayı girişi
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Yaşınızı girin',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                  )
                : Text(
                    _age > 0 ? '$_age' : 'Henüz Yaş Tanımlanmadı',
                    style: const TextStyle(fontSize: 18),
                  ),
            const SizedBox(height: 20.0),

            // Cinsiyet Bilgisi
            const Text(
              'Cinsiyet:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _isEditing
                ? DropdownButtonFormField<String>(
                    value: _gender,
                    hint: const Text('Cinsiyet seçin'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _gender = newValue!;
                      });
                    },
                    items: _genders.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                  )
                : Text(
                    _gender.isNotEmpty && _gender != "BELİRTMEK İSTEMİYORUM" ? _gender : 'Henüz Cinsiyet Tanımlanmadı',
                    style: const TextStyle(fontSize: 18),
                  ),
            const SizedBox(height: 20.0),

            // Not Bilgisi
            const Text(
              'Notlar:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _isEditing
                ? TextFormField(
                    controller: _notesController,
                    maxLines: 4, // Çok satırlı giriş için
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ek notlarınızı buraya yazın...',
                      alignLabelWithHint: true, // Hint metnini yukarı hizala
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                  )
                : Text(
                    _notes.isNotEmpty ? _notes : 'Henüz Not Tanımlanmadı',
                    style: const TextStyle(fontSize: 18),
                  ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}