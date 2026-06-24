import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:my_utility_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GlobalNavigationOverlay(),
    ),
  );
}

class GlobalNavigationOverlay extends StatefulWidget {
  const GlobalNavigationOverlay({super.key});

  @override
  State<GlobalNavigationOverlay> createState() => _GlobalNavigationOverlayState();
}

class _GlobalNavigationOverlayState extends State<GlobalNavigationOverlay> {
  double currentVolume = 0.5;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    // Updated to use the .instance property required by volume_controller 3.x
    VolumeController.instance.getVolume().then((volume) => setState(() {
          currentVolume = volume;
        }));
  }

  void _adjustVolume(bool increase) {
    if (increase) {
      currentVolume = (currentVolume + 0.1).clamp(0.0, 1.0);
    } else {
      currentVolume = (currentVolume - 0.1).clamp(0.0, 1.0);
    }
    // Updated to use the .instance property
    VolumeController.instance.setVolume(currentVolume);
    setState(() {});
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
      // Updated to use the .instance property
      VolumeController.instance.setVolume(isMuted ? 0.0 : 0.5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: Colors.white12, width: 1.5),
            boxShadow: const [
              BoxShadow(color: Colors.black54, blurRadius: 12, spreadRadius: 2)
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.drag_indicator, color: Colors.white38, size: 20),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                onPressed: () => print("Back Key Pressed"),
              ),
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 22),
                onPressed: () => print("Home Key Pressed"),
              ),
              const VerticalDivider(color: Colors.white24, width: 10, thickness: 1),
              IconButton(
                icon: const Icon(Icons.volume_down, color: Colors.lightBlueAccent, size: 22),
                onPressed: () => _adjustVolume(false),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up, color: Colors.lightBlueAccent, size: 22),
                onPressed: () => _adjustVolume(true),
              ),
              IconButton(
                icon: Icon(
                  isMuted ? Icons.volume_off : Icons.volume_mute, 
                  color: isMuted ? Colors.orangeAccent : Colors.white,
                  size: 22
                ),
                onPressed: _toggleMute,
              ),
              const VerticalDivider(color: Colors.white24, width: 10, thickness: 1),
              IconButton(
                icon: const Icon(Icons.power_settings_new, color: Colors.redAccent, size: 22),
                onPressed: () async {
                  await FlutterOverlayWindow.closeOverlay();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}