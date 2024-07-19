import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:imtihon_4oyuchun/ui/screens/registration_screen/registeration_screen.dart';
import 'package:imtihon_4oyuchun/utils/extension/extension.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../../utils/image_path/images_path.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late YandexMapController controller;
  bool _isMapReady = false;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _getCurrentLocation();
  }


  Future<void> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: isLiked
                ? Icon(Icons.favorite, color: Colors.red)
                : Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              height: 300.h,
              width: double.infinity,
              child: Image.asset(
                AppImages.onMoon,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Satellite mega festival for designers",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.white),
              title: Text("14 Iyul, 2024", style: TextStyle(color: Colors.white)),
              subtitle: Text("Yakshanba, 4:00PM - 9:00PM", style: TextStyle(color: Colors.white54)),
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.white),
              title: Text("Yoshlar ijod saroyi", style: TextStyle(color: Colors.white)),
              subtitle: Text("Mustaqillik ko'chasi, Toshkent", style: TextStyle(color: Colors.white54)),
            ),
            ListTile(
              leading: Icon(Icons.people, color: Colors.white),
              title: Text("243 kishi bormoqda", style: TextStyle(color: Colors.white)),
              subtitle: Text("Siz ham ro'yxatdan o'ting", style: TextStyle(color: Colors.white54)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(AppImages.onSun),
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Alisher Zokirov", style: TextStyle(color: Colors.white)),
                      Text("Tadbir tashkilotchisi", style: TextStyle(color: Colors.white54)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Tadbir haqida",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Sevimli taomingizdan va do'stlaringiz va oilaingizdan zavqlaning va vaqtni ajoyib o'tkazing. Mahalliy oziq-ovqat yuk mashinalaridan oziq-ovqat sotib olish mumkin bo'ladi.",
                style: TextStyle(color: Colors.white54),
              ),
            ),
            SizedBox(
              height: 200,
              child: _isMapReady
                  ? YandexMap(
                onMapCreated: (YandexMapController yandexMapController) async {
                  controller = yandexMapController;
                  await controller.moveCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: Point(latitude: 41.2995, longitude: 69.2401),
                        zoom: 12.0,
                      ),
                    ),
                  );
                },
              )
                  : Center(child: CircularProgressIndicator()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return EventRegistrationScreen();
                  }));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                child: Text("Ro'yxatdan O'tish"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
