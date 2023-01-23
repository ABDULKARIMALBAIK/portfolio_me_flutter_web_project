import 'package:flutter/material.dart';
import 'package:portfolio_me/utils/PlatformDetector.dart';
import 'package:seo_renderer/renderers/image_renderer/image_renderer.dart';
import 'package:url_launcher/link.dart';

class AdaptiveImage extends StatelessWidget {

  final String hintLabel;
  final String label;
  final Widget widget;
  final LinkTarget target;
  final String link;
  final String altImage;

  const AdaptiveImage({
    required this.widget,
    this.label = '',
    this.hintLabel = '',
    this.target = LinkTarget.blank,
    this.link = '',
    this.altImage = ''
  });


  @override
  Widget build(BuildContext context) {

    return PlatformDetector().isWeb()
        ?
        ImageRenderer(
          alt: altImage,
          link: link,
          child: Semantics(
            onTap: (){},
            label: label,
            hint: hintLabel,
            child: Link(
              uri: Uri.parse(link),
              target: target,
              builder: (context,follow){
                return widget;
              },
            ),
          ),
        )
        :
    Semantics(
        onTap: (){},
        label: label,
        hint: hintLabel,
        child: widget
    );
  }
}