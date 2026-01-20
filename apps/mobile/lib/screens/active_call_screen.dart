import 'package:flutter/material.dart';

class ActiveCallScreen extends StatefulWidget {
  final String peerName;

  const ActiveCallScreen({super.key, required this.peerName});

  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full screen peer video (Placeholder image)
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1000&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay for better visibility of controls
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                  stops: const [0.0, 0.2, 0.8, 1.0],
                ),
              ),
            ),
          ),
          // Small local video preview
          Positioned(
            bottom: 120,
            right: 20,
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24, width: 1),
                image: const DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/150?img=32'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Call Controls
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCallAction(Icons.auto_awesome, 'Effects', Colors.grey.withOpacity(0.3)),
                _buildCallAction(Icons.mic, 'Mute', Colors.grey.withOpacity(0.3)),
                _buildCallAction(Icons.flip_camera_android, 'Flip', Colors.grey.withOpacity(0.3)),
                _buildCallAction(Icons.call_end, 'End', Colors.red, isEnd: true),
              ],
            ),
          ),
          // Info overlay
          Positioned(
            top: 60,
            left: 24,
            child: const Icon(Icons.info_outline, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildCallAction(IconData icon, String label, Color color, {bool isEnd = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ],
    );
  }
}
