import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:portfolio/game/dino_game.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/ui/info_overlay.dart';
import 'package:portfolio/ui/contact_content.dart';
import 'package:portfolio/ui/portfolio_map_view.dart';

// Controller to sync Game and Map
final ValueNotifier<int> _currentStopNotifier = ValueNotifier<int>(0);
final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier<bool>(false);

// Create the game instance globally so overlays can access it
final _game = DinoGame(
  onSegmentCompleted: (index) {
    _currentStopNotifier.value = index;
  },
  onGameStateChanged: (isPlaying) {
    _isPlayingNotifier.value = isPlaying;
  },
);

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Layer 1: The Real Map (Background)
            Positioned.fill(
              child: ValueListenableBuilder<int>(
                valueListenable: _currentStopNotifier,
                builder: (context, currentStop, _) {
                  return ValueListenableBuilder<bool>(
                      valueListenable: _isPlayingNotifier,
                      builder: (context, isPlaying, _) {
                        return PortfolioMapView(
                          currentStopIndex: currentStop,
                          isPlaying: isPlaying,
                        );
                      });
                },
              ),
            ),

            // Layer 2: Black overlay for contrast (Optional, low opacity)
            Positioned.fill(
              child: Container(color: Colors.white.withValues(alpha: 0.5)),
            ),

            // Layer 3: The Game (Foreground)
            Positioned.fill(
              child: GameWidget(
                game: _game,
                overlayBuilderMap: {
                  'Intro': (context, _) => InfoOverlay(
                      title: PortfolioData.data['Intro']['title'],
                      content: PortfolioData.data['Intro']['content'],
                      onClose: () {
                        _game.overlays.remove('Intro');
                        _game.resumeGame();
                      }),
                  'Education': (context, _) => InfoOverlay(
                      title: PortfolioData.data['Education']['title'],
                      content: PortfolioData.data['Education']['content'],
                      onClose: () {
                        _game.overlays.remove('Education');
                        _game.resumeGame();
                      }),
                  'Skills': (context, _) => InfoOverlay(
                      title: PortfolioData.data['Skills']['title'],
                      content: PortfolioData.data['Skills']['content'],
                      customWidget: const SkillsContent(),
                      onClose: () {
                        _game.overlays.remove('Skills');
                        _game.resumeGame();
                      }),
                  'Experience': (context, _) => InfoOverlay(
                      title: PortfolioData.data['Experience']['title'],
                      content: PortfolioData.data['Experience']['content'],
                      onClose: () {
                        _game.overlays.remove('Experience');
                        _game.resumeGame();
                      }),
                  'Projects': (context, _) => InfoOverlay(
                      title: "Projects",
                      content: "",
                      customWidget: const ProjectsContent(),
                      onClose: () {
                        _game.overlays.remove('Projects');
                        _game.resumeGame();
                      }),
                  'Contact': (context, _) => InfoOverlay(
                      title: PortfolioData.data['Contact']['title'],
                      content: PortfolioData.data['Contact']['content'],
                      customWidget: const ContactContent(),
                      onClose: () {
                        _game.overlays.remove('Contact');
                        _game
                            .continueAfterContact(); // Increment score and continue
                      }),
                  'GameOver': (context, _) => Center(
                        child: Card(
                          color: Colors.black87,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Game Over",
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white)),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    _game.overlays.remove('GameOver');
                                    _game.startGame();
                                    _currentStopNotifier.value = 0; // Reset map
                                  },
                                  child: const Text("Restart"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                },
              ),
            ),
            // Layer 4: Version Tag
            const Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                'v1.0.1 - Features Deployment Test',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
