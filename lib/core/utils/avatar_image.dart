import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';

/// Kullanıcı kendi fotoğrafını yüklemediğinde, kaydına cinsiyetine göre
/// yer tutucu bir profil fotoğrafı atar. Aynı [seed] (ör. userId) her
/// zaman aynı fotoğrafı verir, böylece bir kullanıcının fotoğrafı
/// uygulama içinde tutarlı kalır.
String placeholderAvatarFor(String? gender, String seed) {
  final pool = gender == 'erkek'
      ? AppAssets.profilePhotosMale
      : gender == 'kadin'
          ? AppAssets.profilePhotosFemale
          : [...AppAssets.profilePhotosFemale, ...AppAssets.profilePhotosMale];
  final index = seed.hashCode.abs() % pool.length;
  return pool[index];
}

/// [DecorationImage]/[Image] gibi bir [ImageProvider] bekleyen yerler için:
/// [url] yerel bir asset yoluysa ('assets/...') [AssetImage], aksi halde
/// [NetworkImage] döner.
ImageProvider avatarImageProvider(String url) {
  return url.startsWith('assets/') ? AssetImage(url) : NetworkImage(url);
}

/// Profil fotoğrafı gösteren yerlerde kullanılır: [url] yerel bir asset
/// yoluysa ('assets/...') [Image.asset], aksi halde network URL'i olarak
/// [CachedNetworkImage] ile yükler. Her ikisi de [size]x[size] kutuya
/// [BoxFit.cover] ile sığdırılır (taşma/deformasyon olmaz).
Widget buildAvatarImage(
  String url, {
  required double size,
  required Widget placeholder,
}) {
  if (url.startsWith('assets/')) {
    return Image.asset(
      url,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
  return CachedNetworkImage(
    imageUrl: url,
    width: size,
    height: size,
    fit: BoxFit.cover,
    placeholder: (_, _) => placeholder,
    errorWidget: (_, _, _) => placeholder,
  );
}
