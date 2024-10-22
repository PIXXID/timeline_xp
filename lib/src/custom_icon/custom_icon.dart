import 'package:flutter/material.dart';

class CustomIcon extends StatefulWidget {
  const CustomIcon({
    super.key,
    this.width,
    this.height,
    required this.icon,
    required this.size,
    required this.color,
  });

  final double? width;
  final double? height;
  final String icon;
  final double size;
  final Color color;

  @override
  State<CustomIcon> createState() => _CustomIconState();
}

class _CustomIconState extends State<CustomIcon> {
  dynamic iconCode;

  @override
  void initState() {
    super.initState();

    switch (widget.icon) {
      case 'sun-bright':
        iconCode = 0xe800;
        break;
      case 'bars-filter':
        iconCode = 0xe828;
        break;
      case 'file-heart':
        iconCode = 0xe804;
        break;
      case 'chevron-left':
        iconCode = 0xe801;
        break;
      case 'trophy-start':
        iconCode = 0xe81a;
        break;
      case 'fire':
        iconCode = 0xe803;
        break;
      case 'paperclip':
        iconCode = 0xe813;
        break;
      case 'cicle-exclamation':
        iconCode = 0xe807;
        break;
      case 'thumbs-up':
        iconCode = 0xe814;
        break;
      case 'hand-holding-heart':
        iconCode = 0xe805;
        break;
      case 'face-thinking':
        iconCode = 0xe80d;
        break;
      case 'light-bulb':
        iconCode = 0xe80b;
        break;
      case 'close':
        iconCode = 0xe809;
        break;
      case 'user-clock':
        iconCode = 0xe80c;
        break;
      case 'comments':
        iconCode = 0xe80a;
        break;
      case 'book':
        iconCode = 0xe810;
        break;
      case 'ellipsis-horizontal':
        iconCode = 0xe80f;
        break;
      case 'microphone':
        iconCode = 0xe806;
        break;
      case 'paper-plane':
        iconCode = 0xe81b;
        break;
      case 'comment':
        iconCode = 0xe80e;
        break;
      case 'flag-pennant':
        iconCode = 0xe825;
        break;
      case 'pen-to-square':
        iconCode = 0xe812;
        break;
      case 'bell-on':
        iconCode = 0xe827;
        break;
      case 'hourglass-clock':
        iconCode = 0xe811;
        break;
      case 'triangle-exclamation':
        iconCode = 0xe818;
        break;
      case 'list-checked':
        iconCode = 0xe802;
        break;
      case 'chart-mixed-up-circle-dollar':
        iconCode = 0xe815;
        break;
      case 'chart-bar':
        iconCode = 0xe817;
        break;
      case 'chart-mixed-up-circle-currency':
        iconCode = 0xe819;
        break;
      case 'gear':
        iconCode = 0xe816;
        break;
      case 'circle-interrogation':
        iconCode = 0xe81d;
        break;
      case 'user-home':
        iconCode = 0xe81e;
        break;
      case 'list':
        iconCode = 0xe808;
        break;
      case 'bell':
        iconCode = 0xe820;
        break;
      case 'user':
        iconCode = 0xe81c;
        break;
      case 'face-cry':
        iconCode = 0xe81f;
        break;
      case 'face-sad':
        iconCode = 0xe824;
        break;
      case 'face-neutral':
        iconCode = 0xe821;
        break;
      case 'face-smile':
        iconCode = 0xe822;
        break;
      case 'face-happy':
        iconCode = 0xe826;
        break;
      default:
        iconCode = 0xe826;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
        IconData(
          iconCode,
          fontFamily: 'Swiiipiconsfont',
        ),
        color: widget.color,
        size: widget.size);
  }
}
