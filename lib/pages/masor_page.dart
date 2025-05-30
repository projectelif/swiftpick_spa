import 'package:flutter/material.dart';

class MasorPage extends StatefulWidget {
  @override
  _MasorPageState createState() => _MasorPageState();
}

class _MasorPageState extends State<MasorPage> {
   final PageController _pageController = PageController();
  int _currentPage = 0;

    final List<UserData> users = [
    UserData(
      name: 'Elif Demir',
      info: 'Uzun yıllardır masaj terapisi alanında hizmet veren Elif Demir, bedenin doğal iyileşme gücüne inanarak her seansı kişiye özel olarak planlamaktadır. Klasik masaj, derin doku, refleksoloji ve aromaterapi gibi çeşitli tekniklerde uzmanlaşmıştır. Danışanlarının hem fiziksel hem de zihinsel olarak rahatlamasını sağlamak, onun en büyük motivasyonudur. Sakin ve güven verici yaklaşımıyla, konforlu bir ortamda profesyonel hizmet sunmayı ilke edinmiştir.',
      imagePath: 'assets/1.png',
    ),
    UserData(
      name: 'Zeynep Kaya',
      info: '6 yıldır masaj terapisi alanında hizmet veren Zeynep Kaya, Medikal masaj konusunda uzmanlaşmıştır. Bunun yanında klasik masaj, derin doku, thai ve bali gibi çeşitli tekniklerde yetkinliği vardır. Danışanlarının hem fiziksel hem de zihinsel olarak rahatlamasını sağlamak, onun en büyük motivasyonudur. Sakin ve güven verici yaklaşımıyla, konforlu bir ortamda profesyonel hizmet sunmayı ilke edinmiştir.',
      imagePath: 'assets/2.png',
    ),
    UserData(
      name: 'Ali Taşkın',
      info: '5 yılı aşkın süredir profesyonel masaj terapisti olarak çalışan Ali Taşkın, anatomi bilgisi ve farklı masaj tekniklerindeki uzmanlığıyla danışanlarına fiziksel ve zihinsel rahatlama sağlamayı hedeflemektedir. Klasik İsveç masajı, derin doku masajı ve aromaterapi konularında eğitim almış olup, her danışana özel ihtiyaçlara göre seanslar planlamaktadır. Misafir memnuniyetine önem veren, güvenli ve konforlu bir ortamda hizmet sunmayı ilke edinmiştir.',
      imagePath: 'assets/3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // PageView
            PageView.builder(
              controller: _pageController,
              itemCount: users.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return UserProfilePage(user: users[index]);
              },
            ),
            // Sol üst köşede geri butonu
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
            // Nokta göstergesi
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(users.length, (index) {
                  bool isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    width: isActive ? 14 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.blueAccent : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  final UserData user;

  const UserProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Fotoğraf
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(user.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Bilgiler
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Center(child: Text( user.name , style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
              SizedBox(height: 10),
              Text(user.info),
            ],
          ),
        ],
      ),
    );
  }
}



class UserData {
  final String name;
  final String info;
  final String imagePath;

  UserData({
    required this.name,
    required this.info,
    required this.imagePath,
  });
}