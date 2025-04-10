import 'package:flutter/material.dart';
import 'package:flutter_xy_markdown/controllers/xy_fill_markdown_controller.dart';
import 'package:flutter_xy_markdown/markdown_custom/custom_super_node.dart';
import 'package:flutter_xy_markdown/widgets/xy_text_selection_toolbar.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/config/markdown_generator.dart';
import 'package:markdown_widget/widget/blocks/leaf/link.dart';
import 'package:markdown_widget/widget/blocks/leaf/paragraph.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:markdown_widget/markdown_widget.dart';

// typedef linkTextStyleBuilder = TextStyle Function(TextStyle textStyle);

class XYFillMarkdown extends StatefulWidget {
  final TextStyle textStyle;
  final TextStyle? linkTextStyle;
  final XYFillMarkdownController controller;
  final ValueChanged<String>? onTap;
  final bool shrinkWrap;
  final TextAlign? textAlign;
  const XYFillMarkdown({
    super.key,
    required this.textStyle,
    this.linkTextStyle,
    required this.controller,
    this.shrinkWrap = false,
    this.onTap,
    this.textAlign,
  });

  @override
  State<XYFillMarkdown> createState() => _XYFillMarkdownState();
}

class _XYFillMarkdownState extends State<XYFillMarkdown> {
  late XYFillMarkdownController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  void didUpdateWidget(XYFillMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      controller = widget.controller;
    }
  }

  get markdownWidget {
    return MarkdownWidget(
      selectable: false,
      shrinkWrap: widget.shrinkWrap,
      data: controller.getText(),
      config: MarkdownConfig(configs: [
        PConfig(
          textStyle: widget.textStyle,
        ),
        LinkConfig(
          style: widget.linkTextStyle ?? widget.textStyle,
          onTap: (url) {
            if (widget.onTap != null) {
              widget.onTap!(url);
            }
          },
        )
      ]),
      markdownGenerator: MarkdownGenerator(
        richTextBuilder: (InlineSpan span) {
          return Text.rich(
            span,
            textAlign: widget.textAlign ?? TextAlign.justify,
          );
        },
        onNodeAccepted: (node, index) {
          if (node is ImageNode) {
            print("node.attributes: ${node.attributes}");
            node.attributes["src"] =
                "https://5i5lab.oss-cn-hangzhou.aliyuncs.com${node.attributes["src"]}";
          }
        },
        textGenerator: (node, config, visitor) => CustomSuperNode(
          node.textContent,
          config,
          visitor,
          controller.dataMapBuilder?.call() ?? {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return controller.selectable
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
