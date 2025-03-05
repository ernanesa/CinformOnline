import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  final AdSize size;
  final String adUnitId; // ID do bloco de anúncio Banner

  BannerAdWidget({Key? key, this.size = AdSize.banner, required this.adUnitId})
    : super(key: key);

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId:
          widget
              .adUnitId, // Use o ID do bloco de anúncio passado como parâmetro
      request: const AdRequest(),
      size: widget.size,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
          print('Anúncio Banner carregado');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Falha ao carregar anúncio Banner: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('Anúncio Banner aberto'),
        onAdClosed: (Ad ad) => print('Anúncio Banner fechado'),
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAdLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: widget.size.width.toDouble(),
        height: widget.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      return Container(
        // Placeholder enquanto o anúncio não carrega
        width: widget.size.width.toDouble(),
        height: widget.size.height.toDouble(),
      );
    }
  }
}
