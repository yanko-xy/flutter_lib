// Copyright 2025 sheepzhao
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class XYTestMarkdown extends StatelessWidget {
  final String data;
  const XYTestMarkdown({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      controller: ScrollController(),
      styleSheet: MarkdownStyleSheet(
        textAlign: WrapAlignment.spaceAround,
        p: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        a: const TextStyle(
          fontSize: 16,
          color: Colors.purple,
        ),
      ),
      selectable: true,
      data: data,
    );
  }
}
