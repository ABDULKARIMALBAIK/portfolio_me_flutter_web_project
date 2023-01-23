import 'package:flutter/material.dart';
import 'package:portfolio_me/utils/PlatformDetector.dart';
import 'package:seo_renderer/renderers/text_renderer/text_renderer.dart';


class AdaptiveText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final int maxLines;
  final String hintLabel;
  final String label;

  const AdaptiveText({
    required this.text,
    required this.style,
    this.maxLines = 1,
    this.label = '',
    this.hintLabel = '',
    this.textAlign = TextAlign.start
  });

  @override
  Widget build(BuildContext context) {
    return PlatformDetector().isWeb()
        ?
    TextRenderer(
      text: Semantics(
        onTap: (){},
        label: label,
        hint: hintLabel,
        child: TextSelectionTheme(
          data: TextSelectionThemeData(
            cursorColor: Theme.of(context).primaryColor,
            selectionColor: Theme.of(context).primaryColor.withOpacity(0.5),
            selectionHandleColor: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          child: SelectableText(
            text,
            style: style,
            // overflow: TextOverflow.ellipsis,
            // softWrap: true,
            maxLines: maxLines,
            cursorWidth: 2,
            textAlign: textAlign,
            cursorRadius: Radius.circular(20),
            enableInteractiveSelection: true,
            toolbarOptions: ToolbarOptions(
                copy: true,
                selectAll: true
            ),
            onSelectionChanged: (selection , cause){

            },
          ),
        ),
      ),
    )
        :
    Semantics(
      onTap: (){},
      label: label,
      hint: hintLabel,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        softWrap: true,
        semanticsLabel: label,
      ),
    );
  }
}