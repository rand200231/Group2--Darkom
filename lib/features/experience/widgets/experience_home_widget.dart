import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/core/models/experience_model.dart';

import '../experience_screen.dart';

class ExperienceHomeWidget extends StatelessWidget {
  const ExperienceHomeWidget({super.key, required this.experience, required this.isFavorite, this.onFavoriteTap});

  final ExperienceModel experience;
  final bool isFavorite;
  final Function()? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExperienceScreen(experience: experience))),
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(bottom: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: const Color(0xFF000000), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ]
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (experience.photos.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: experience.photos.first,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => LinearProgressIndicator(
                    color: Colors.white,
                    value: 0.5,
                    minHeight: 50,
                  ),
                  placeholder: (context, url) => LinearProgressIndicator(
                    color: Colors.white,
                    // backgroundColor: Colors.white,
                    minHeight: 50,
                  ),
                ),
              ),
            const SizedBox(height: 5),
            
            Text(
              experience.name,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF4d2f14),
              ),
            ),
            const SizedBox(height: 5),
      
            Text(
              experience.description,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF4d2f14),
              ),
            ),
            const SizedBox(height: 10),
      
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    onFavoriteTap?.call();
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Spacer(),
      
                Text(
                  '${experience.price} SAR',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF4d2f14),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}