import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown/markdown.dart' as m;
import 'html_support.dart';

class FillTextNode extends ElementNode {
  final String text;
  final MarkdownConfig config;
  final WidgetVisitor visitor;
  final Color fillBackgroundColor;

  FillTextNode(
    this.text,
    this.config,
    this.visitor,
    this.fillBackgroundColor,
  );

  @override
  void onAccepted(SpanNode parent) {
    final textStyle = config.p.textStyle.merge(parentStyle);
    children.clear();

    // 如果文本中不包含 HTML 表示形式，直接接受普通文本节点
    if (!text.contains(htmlRep)) {
      accept(TextNode(text: text, style: textStyle));
      return;
    }

    // 解析 HTML 内容
    final spans = parseHtml(
      m.Text(text),
      visitor: WidgetVisitor(
        config: visitor.config,
        generators: visitor.generators,
        richTextBuilder: visitor.richTextBuilder,
      ),
      parentStyle: parentStyle,
    );

    // 遍历解析后的节点
    for (var element in spans) {
      if (element is ConcreteElementNode && element.children[0] is LinkNode) {
        LinkNode linkNode = element.children[0] as LinkNode;

        // 如果是 <a> 标签，添加遮挡层逻辑
        TextStyle linkStyle = textStyle.merge(linkNode.style);
        if (linkNode.attributes.containsKey("hidden")) {
          linkStyle = linkStyle.copyWith(
            color: Colors.transparent, // 使文字不可见
            background: Paint()..color = fillBackgroundColor, // 红色遮挡
          );
        }
        final linkText = linkNode.children
            .firstWhere((child) => child is TextNode) as TextNode?;
        linkNode.children.clear();
        if (linkText != null) {
          linkNode.children
              .add(TextNode(text: linkText.text, style: linkStyle));
          accept(linkNode);
        }
      } else {
        // 普通节点直接接受
        accept(element);
      }
    }
  }
}
