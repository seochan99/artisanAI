import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nau/banner_detail_screen.dart';

class BannerSwiper extends StatelessWidget {
  final List<String> images = [
    "https://i.pinimg.com/564x/04/fc/6f/04fc6fe04fbc67285b58012b9d71deb1.jpg",
    "https://i.pinimg.com/564x/dc/fd/4d/dcfd4d210178c8686c5bab4699587258.jpg",
    "https://i.pinimg.com/564x/2c/5d/7a/2c5d7ab4ab48a6194afc6cb11dc3772e.jpg",
  ];

  final List<String> captions = [
    "내가 만드는 UI/UX Nau Bot이란??",
    "Nau를 즐기는 5가지 방법 ",
    "Nau Bot 이용시 유의할점",
  ];

  final List<String> contents = [
    """안녕하세요!\n
\n
내가 만드는 UI/UX, Nau Bot 입니다.\n
\n
Nau Bot은 Dall-E-2 Model를 이용하여 \n
개인만의 UI/UX 생성에 도움을 줍니다.\n
\n
[title]개인 맞춤형 디자인\n
\n
사람마다 원하는 디자인은 다릅니다..\n
하지만, 현재 디자인 제작 서비스는\n
특정 분야의 디자인에 대해서는 제작을 해주지 않습니다.\n
\n
하지만, Nau bot은 WEB/APP UI/UX디자인에 특화되어\n
웹, 앱 분야의 디자인을 원하는 사람에게 맞춰 디자인을 제공해줍니다.\n
\n
[title]나만의 디자인 공유 플랫폼\n
\n
Nau와의 대화를 통해 원하는 디자인을 얻으셨나요?!?\n
나만의 디자인을 다른이에게 공유할 수 있습니다!!\n
이를 통해 다른이의 디자인을 보고, 나만의 디자인을 공유하는 공간을 가져봐요:)\n""",
    """안녕하세요!\n
\n
내가 만드는 UI/UX, Nau Bot 입니다.\n
\n
Nau Bot은 Dall-E-2 Model를 이용하여 \n
개인만의 UI/UX 생성에 도움을 줍니다.\n
\n
[title]개인 맞춤형 디자인\n
\n
사람마다 원하는 디자인은 다릅니다..\n
하지만, 현재 디자인 제작 서비스는\n
특정 분야의 디자인에 대해서는 제작을 해주지 않습니다.\n
\n
하지만, Nau bot은 WEB/APP UI/UX디자인에 특화되어\n
웹, 앱 분야의 디자인을 원하는 사람에게 맞춰 디자인을 제공해줍니다.\n
\n
[title]나만의 디자인 공유 플랫폼\n
\n
Nau와의 대화를 통해 원하는 디자인을 얻으셨나요?!?\n
나만의 디자인을 다른이에게 공유할 수 있습니다!!\n
이를 통해 다른이의 디자인을 보고, 나만의 디자인을 공유하는 공간을 가져봐요:)\n""",
    """안녕하세요!\n
\n
내가 만드는 UI/UX, Nau Bot 입니다.\n
\n
Nau Bot은 Dall-E-2 Model를 이용하여 \n
개인만의 UI/UX 생성에 도움을 줍니다.\n
\n
[title]개인 맞춤형 디자인\n
\n
사람마다 원하는 디자인은 다릅니다..\n
하지만, 현재 디자인 제작 서비스는\n
특정 분야의 디자인에 대해서는 제작을 해주지 않습니다.\n
\n
하지만, Nau bot은 WEB/APP UI/UX디자인에 특화되어\n
웹, 앱 분야의 디자인을 원하는 사람에게 맞춰 디자인을 제공해줍니다.\n
\n
[title]나만의 디자인 공유 플랫폼\n
\n
Nau와의 대화를 통해 원하는 디자인을 얻으셨나요?!?\n
나만의 디자인을 다른이에게 공유할 수 있습니다!!\n
이를 통해 다른이의 디자인을 보고, 나만의 디자인을 공유하는 공간을 가져봐요:)\n""",
  ];

  BannerSwiper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          CarouselSlider(
            items: images.asMap().entries.map((entry) {
              final index = entry.key;
              final imageUrl = entry.value;
              final caption = captions[index];
              final content = contents[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BannerDetailScreen(
                        caption: caption,
                        content: content,
                      ),
                    ),
                  );
                },
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.4),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  caption,
                                  style: const TextStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "더 알아보기 >",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: false,
              viewportFraction: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
