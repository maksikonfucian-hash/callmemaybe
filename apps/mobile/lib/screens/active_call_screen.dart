import 'package:flutter/material.dart';

/// Screen for active video call.
class ActiveCallScreen extends StatefulWidget {
  final String peerName;

  const ActiveCallScreen({super.key, required this.peerName});

  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  bool isMuted = false;
  bool isCameraFlipped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full screen peer video (placeholder)
          Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'Peer Video',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          // Top overlay
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 16),
                Text(
                  widget.peerName,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          // Floating own video
          Positioned(
            top: 100,
            right: 20,
            child: Container(
              width: 120,
              height: 160,
              color: Colors.grey,
              child: const Center(
                child: Text('Own Video'),
              ),
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    // Effects placeholder
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Effects')),
                    );
                  },
                  child: const Icon(Icons.filter),
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isMuted = !isMuted;
                    });
                  },
                  backgroundColor: isMuted ? Colors.red : null,
                  child: Icon(isMuted ? Icons.mic_off : Icons.mic),
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isCameraFlipped = !isCameraFlipped;
                    });
                  },
                  child: const Icon(Icons.flip_camera_android),
                ),
                FloatingActionButton(
                  onPressed: () {
                    // End call
                    Navigator.of(context).pop();
                    // TODO: Add to call history
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}