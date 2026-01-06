import 'package:flutter/material.dart';
export 'package:portfolio/aboutContent.dart';

class InfoOverlay extends StatelessWidget {
  final String title;
  final String content;
  final Widget? customWidget;
  final VoidCallback onClose;

  const InfoOverlay({
    Key? key,
    required this.title,
    required this.content,
    this.customWidget,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isSmallScreen ? screenSize.width * 0.9 : 600,
          maxHeight: screenSize.height * 0.85,
        ),
        child: Card(
          color: Colors.grey[900]!.withOpacity(0.95),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title and close button
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 24,
                  vertical: isSmallScreen ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: onClose,
                      iconSize: isSmallScreen ? 24 : 28,
                    ),
                  ],
                ),
              ),
              // Scrollable content area
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (content.isNotEmpty)
                        Text(
                          content,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.grey[300],
                            height: 1.5,
                          ),
                        ),
                      if (content.isNotEmpty && customWidget != null)
                        SizedBox(height: isSmallScreen ? 16 : 24),
                      if (customWidget != null) customWidget!,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
