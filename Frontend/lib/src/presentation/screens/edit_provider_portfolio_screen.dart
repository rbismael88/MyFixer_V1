
import 'package:flutter/material.dart';

class EditProviderPortfolioScreen extends StatefulWidget {
  const EditProviderPortfolioScreen({super.key});

  @override
  State<EditProviderPortfolioScreen> createState() => _EditProviderPortfolioScreenState();
}

class _EditProviderPortfolioScreenState extends State<EditProviderPortfolioScreen> {
  final List<String> _portfolioImages = [
    // Placeholder images
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Editar Portafolio', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              // Save logic here
              Navigator.pop(context);
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _portfolioImages.length + 1, // +1 for the add button
          itemBuilder: (context, index) {
            if (index == _portfolioImages.length) {
              return _buildAddButton();
            }
            return _buildPortfolioItem(_portfolioImages[index]);
          },
        ),
      ),
    );
  }

  Widget _buildPortfolioItem(String imageUrl) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.black.withAlpha((0.6 * 255).round()),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 14),
              onPressed: () {
                setState(() {
                  _portfolioImages.remove(imageUrl);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: () {
        // Add new image logic
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Icons.add_a_photo, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}
