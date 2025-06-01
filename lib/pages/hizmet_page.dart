import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class HizmetPage extends StatefulWidget {
  @override
  _HizmetPageState createState() => _HizmetPageState();
}

class _HizmetPageState extends State<HizmetPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<MasajData> massages = [
    MasajData(
      name: 'Thai Masajı',
      info:
          'Geleneksel Tayland kökenli bir masaj türüdür. Diğer klasik masajlardan farklı olarak Thai masajında yağ kullanılmaz ve masaj, yerde özel bir minderde yapılır. Kişi genellikle rahat kıyafetler giyer ve tüm vücut üzerinde gerçekleştirilir. Thai masajı, yoga ve akupresür tekniklerini birleştirerek kasları esnetmeyi, kan dolaşımını artırmayı ve enerji akışını dengelemeyi amaçlar.',
      imagePath: 'assets/thai.png',
      link: 'https://www.youtube.com/watch?v=8ZAUsoP7wbk',
    ),
    MasajData(
      name: 'Bali Masajı',
      info:
          'Bali Adası’na özgü, rahatlatıcı ve aromaterapi odaklı geleneksel bir masaj türüdür. Yumuşak ama derin dokunuşlarla yapılır ve genellikle bitkisel yağlar kullanılarak uygulanır. Zihinsel ve fiziksel rahatlama sağlamaya odaklanır.',
      imagePath: 'assets/bali.png',
      link: 'https://www.youtube.com/watch?v=Ch5Sl0iPRgY',
    ),
    MasajData(
      name: 'Medikal Masaj',
      info:
          'Doktor ya da fizyoterapist önerisiyle, belirli bir sağlık sorununa yönelik olarak uygulanan tedavi amaçlı masaj türüdür. Klasik masaj tekniklerine benzese de, tedaviye yönelik bir yaklaşımla, belirli bir kas, eklem ya da doku problemi hedeflenerek yapılır.',
      imagePath: 'assets/medical.png',
      link: 'https://www.youtube.com/watch?v=2Mc-U8R168U',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: massages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return UserProfilePage(user: massages[index]);
              },
            ),
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
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(massages.length, (index) {
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
  final MasajData user;

  const UserProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
  final videoId = YoutubePlayer.convertUrlToId(user.link);
  if (videoId != null) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => YoutubeVideoBottomSheet(videoId: videoId),
    );
  }
},
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
          SizedBox(height: 10),
          Center(
            child: Text(
              user.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Text(user.info),
        ],
      ),
    );
  }
}

class YoutubeVideoBottomSheet extends StatefulWidget {
  final String videoId;

  const YoutubeVideoBottomSheet({required this.videoId});

  @override
  _YoutubeVideoBottomSheetState createState() =>
      _YoutubeVideoBottomSheetState();
}

class _YoutubeVideoBottomSheetState extends State<YoutubeVideoBottomSheet> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
                label: Text('Kapat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MasajData {
  final String name;
  final String info;
  final String imagePath;
  final String link;

  MasajData({
    required this.name,
    required this.info,
    required this.imagePath,
    required this.link,
  });
}
