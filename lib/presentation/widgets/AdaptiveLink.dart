import 'package:flutter/material.dart';
import 'package:portfolio_me/utils/PlatformDetector.dart';
import 'package:seo_renderer/renderers/link_renderer/link_renderer.dart';
import 'package:url_launcher/link.dart';


class AdaptiveLink extends StatelessWidget {

  final String hintLabel;
  final String label;
  final Widget widget;
  final LinkTarget target;
  final String link;
  final String anchorText;

  const AdaptiveLink({
    required this.widget,
    this.label = '',
    this.hintLabel = '',
    this.target = LinkTarget.blank,
    this.link = '',
    this.anchorText = ''
  });

  @override
  Widget build(BuildContext context) {
    return PlatformDetector().isWeb()
        ?
    LinkRenderer(
      anchorText: anchorText,
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