import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_xy_markdown/markdown_custom/custom_node.dart';
import 'package:flutter_xy_markdown/markdown_custom/latex.dart';
import 'package:flutter_xy_markdown/widgets/xy_text_selection_toolbar.dart';
import 'package:markdown_widget/markdown_widget.dart';

class XYMarkdown extends StatelessWidget {
  final String data;
  final TextStyle? textStyle;
  final bool selectable;
  final Function(String)? onTap;
  final bool shrinkWrap;
  final TextAlign? textAlign;

  const XYMarkdown({
    super.key,
    required this.data,
    this.textStyle,
    this.selectable = true,
    this.onTap,
    this.shrinkWrap = false,
    this.textAlign,
  });

  get markdownWidget {
    return MarkdownWidget(
      data: data,
      padding: EdgeInsets.zero,
      shrinkWrap: shrinkWrap,
      selectable: false,
      config: MarkdownConfig(configs: [
        PConfig(
          textStyle: textStyle ?? const TextStyle(),
        ),
        LinkConfig(
          style: const TextStyle(
            decoration: TextDecoration.none,
          ),
          onTap: (url) {
            if (onTap != null) {
              onTap!(url);
            }
          },
        )
      ]),
      markdownGenerator: MarkdownGenerator(
        generators: [
          latexGenerator,
        ],
        inlineSyntaxList: [
          LatexSyntax(),
        ],
        linesMargin: const EdgeInsets.only(bottom: 4),
        onNodeAccepted: (node, index) {
          if (node is ImageNode) {
            node.attributes["src"] =
                "https://5i5lab.oss-cn-hangzhou.aliyuncs.com${node.attributes["src"]}";
          }
        },
        richTextBuilder: (InlineSpan span) {
          return Text.rich(
            span,
            textAlign: textAlign ?? TextAlign.justify,
          );
        },
        textGenerator: (node, config, visitor) => CustomTextNode(
          node.textContent,
          config,
          visitor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ScrollController(),
      builder: (context, _) {
        return selectable
            ? SelectionArea(
                contextMenuBuilder: (BuildContext context,
                    SelectableRegionState selectableRegionState) {
                  return XYTextSelectionToolbar.selectableRegion(
                      selectableRegionState: selectableRegionState);
                },
                child: markdownWidget,
              )
            : markdownWidget;
      },
    );
  }
}
