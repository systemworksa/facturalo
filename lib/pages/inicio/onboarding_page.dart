import 'package:facturaloapp2025/widgets/card_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final data = [
    CardPlanetData(
      title: "FACTURACIÓN ELECTRÓNICA",
      subtitle: "Gestione sus documentos desde la facilidad de su móvil.",
      image: const AssetImage("assets/img/portada-1.png"),
      backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
      titleColor: Colors.pink,
      subtitleColor: Colors.white,
      background: LottieBuilder.asset("assets/animation/bg-1.json"),
    ),
    CardPlanetData(
      title: "SERVICIOS",
      subtitle: "Gestione sus clientes, productos y más.",
      image: const AssetImage("assets/img/portada-2.png"),
      backgroundColor: Colors.white,
      titleColor: Colors.purple,
      subtitleColor: const Color.fromRGBO(0, 10, 56, 1),
      background: LottieBuilder.asset("assets/animation/bg-2.json"),
    ),
    CardPlanetData(
      title: "INFORMACIÓN",
      subtitle:
          "Todo almacenado en la nube protegiendo y respaldando tu información siempre al alcance de tus manos.",
      image: const AssetImage("assets/img/portada-3.png"),
      backgroundColor: const Color.fromRGBO(71, 59, 117, 1),
      titleColor: Colors.yellow,
      subtitleColor: Colors.white,
      background: LottieBuilder.asset("assets/animation/bg-3.json"),
    ),
  ];
 // StreamSubscription<ConnectivityResult>? _connectivitySubscription;
 // InternetDialog ? _internetDialog;
 // final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    super.initState();
  //  _internetDialog = InternetDialog(context);
  //  _connectivitySubscription =
  //  _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: data.map((e) => e.backgroundColor).toList(),
        itemCount: data.length,
        itemBuilder: (index) {
          return CardPlanet(data: data[index]);
        },
        onFinish: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('onboard', 'si');

          Navigator.pushNamed(context, 'login');
        },
      ),
    );
  }
}
