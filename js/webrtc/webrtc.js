// WebRTC logic for mesh P2P calls, reusable in Flutter via flutter_js and web.
// Handles offer/answer, ICE candidates, encryption, quality limiting.

// Configuration for ICE servers
const iceServers = [
  { urls: 'stun:stun.l.google.com:19302' },
  { urls: 'turn:turn.example.com', username: 'user', credential: 'pass' }, // Replace with actual TURN
];

// Global variables for the call
let localPeerConnection;
let remotePeerConnections = new Map(); // For mesh
let localStream;
let isEncrypted = true; // Toggleable E2E encryption (simplified)

// Initialize local media
async function initLocalStream(audio = true, video = true) {
  try {
    localStream = await navigator.mediaDevices.getUserMedia({ audio, video });
    // Limit quality if needed
    if (video) {
      const videoTrack = localStream.getVideoTracks()[0];
      const capabilities = videoTrack.getCapabilities();
      if (capabilities.width && capabilities.height) {
        videoTrack.applyConstraints({
          width: { ideal: 640 },
          height: { ideal: 480 },
        });
      }
    }
    return { success: true, stream: localStream };
  } catch (error) {
    return { success: false, error: error.message };
  }
}

// Create peer connection for mesh
function createPeerConnection(peerId) {
  const pc = new RTCPeerConnection({ iceServers });

  // Add local stream
  localStream.getTracks().forEach(track => pc.addTrack(track, localStream));

  // Handle ICE candidates
  pc.onicecandidate = (event) => {
    if (event.candidate) {
      // Send candidate to signaling server for peerId
      sendSignalingMessage(peerId, 'candidate', event.candidate);
    }
  };

  // Handle remote stream
  pc.ontrack = (event) => {
    // Handle remote stream for peerId
    handleRemoteStream(peerId, event.streams[0]);
  };

  remotePeerConnections.set(peerId, pc);
  return pc;
}

// Send offer
async function sendOffer(peerId) {
  const pc = createPeerConnection(peerId);
  const offer = await pc.createOffer();
  await pc.setLocalDescription(offer);
  sendSignalingMessage(peerId, 'offer', offer);
}

// Handle offer
async function handleOffer(peerId, offer) {
  const pc = createPeerConnection(peerId);
  await pc.setRemoteDescription(new RTCSessionDescription(offer));
  const answer = await pc.createAnswer();
  await pc.setLocalDescription(answer);
  sendSignalingMessage(peerId, 'answer', answer);
}

// Handle answer
async function handleAnswer(peerId, answer) {
  const pc = remotePeerConnections.get(peerId);
  if (pc) {
    await pc.setRemoteDescription(new RTCSessionDescription(answer));
  }
}

// Handle ICE candidate
async function handleCandidate(peerId, candidate) {
  const pc = remotePeerConnections.get(peerId);
  if (pc) {
    await pc.addIceCandidate(new RTCIceCandidate(candidate));
  }
}

// Send signaling message (placeholder, integrate with actual signaling)
function sendSignalingMessage(peerId, type, data) {
  // In Flutter, this would be bridged
  console.log(`Sending ${type} to ${peerId}:`, data);
}

// Handle remote stream (placeholder)
function handleRemoteStream(peerId, stream) {
  console.log(`Received stream from ${peerId}`);
  // In Flutter, display the stream
}

// End call
function endCall(peerId) {
  const pc = remotePeerConnections.get(peerId);
  if (pc) {
    pc.close();
    remotePeerConnections.delete(peerId);
  }
}

// Toggle encryption (simplified, actual E2E would use libs like Signal)
function toggleEncryption(enable) {
  isEncrypted = enable;
  // Reinitialize connections if needed
}

// Switch to SFU if mesh unstable (placeholder for LiveKit integration)
function switchToSFU() {
  // Use LiveKit client instead
  console.log('Switching to SFU');
}

// Expose functions to Flutter
window.WebRTC = {
  initLocalStream,
  sendOffer,
  handleOffer,
  handleAnswer,
  handleCandidate,
  endCall,
  toggleEncryption,
  switchToSFU,
};