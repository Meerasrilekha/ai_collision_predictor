# TODO: Enhance AI Collision Predictor App

## Completed Features (Already Implemented)
- [x] Voice Alerts & Audio Feedback
- [x] 3D Flight Path Visualization
- [x] Dynamic Environment Settings
- [x] Real-Time Metric Dashboard Overlay
- [x] User-Controlled Parameters
- [x] Result Export Feature (JSON)
- [x] Performance Monitor Utility
- [x] Theme Customization (Dark Mode Toggle)
- [x] Gesture Controls (AR Page)
- [x] Safety Indicator History Graph

## Enhancements to Implement

### 1. Voice Alerts Enhancement
- [ ] Ensure TTS triggers for "Caution: Close Proximity Detected" and "Conflict Zone Ahead"
- [ ] Update audio_manager.dart to properly call speakAlert on status changes

### 2. 3D Visualization Enhancement
- [ ] Add layered animations and better height variation in SimulationPainter3D
- [ ] Improve depth perception with perspective transforms

### 3. Dynamic Environments Enhancement
- [ ] Make weather dynamically affect collision probability in simulation_provider.dart
- [ ] Adjust movement speed based on weather conditions in environmental_provider.dart

### 4. Real-Time HUD Enhancement
- [ ] Add smooth animations to HUD updates in simulation_page.dart
- [ ] Ensure metrics update every second with transitions

### 5. User Parameters Enhancement
- [ ] Replace text fields with sliders in dashboard.dart settings dialog
- [ ] Improve UX for parameter input

### 6. Export Feature Enhancement
- [ ] Add CSV export option alongside JSON in results_page.dart
- [ ] Update _exportResults method to support both formats

### 7. Performance Monitor Integration
- [ ] Integrate FPS/CPU display in simulation_page.dart
- [ ] Use performance_monitor.dart to show real-time metrics

### 8. Theme Customization Enhancement
- [ ] Add smooth transitions between light/dark modes in dashboard.dart
- [ ] Use AnimatedTheme for seamless switching

### 9. AR Gestures Enhancement
- [ ] Add double-tap and rotation gestures in ar_visualization_page.dart
- [ ] Enhance GestureDetector with more interactions

### 10. Safety Graph Enhancement
- [ ] Change bar chart to line graph for better history visualization in results_page.dart
- [ ] Improve readability of status over time

## Files to Edit
- [ ] lib/pages/simulation_page.dart
- [ ] lib/pages/dashboard.dart
- [ ] lib/pages/results_page.dart
- [ ] lib/providers/simulation_provider.dart
- [ ] lib/providers/environmental_provider.dart
- [ ] lib/utils/audio_manager.dart
- [ ] lib/pages/ar_visualization_page.dart

## Followup Steps
- [ ] Test voice alerts and audio feedback
- [ ] Verify performance monitor display
- [ ] Test export to JSON and CSV
- [ ] Test enhanced gestures and theme transitions
- [ ] Run app in emulator to verify all features
