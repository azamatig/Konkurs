import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class HandCursor extends MouseRegion {
  static final appContainer = window.document.getElementById('app-container');

  HandCursor({@required Widget child})
      : super(onHover: _mouseOnHover, onExit: _mouseOnExit, child: child);

  static void _mouseOnHover(PointerHoverEvent event) {
    appContainer.style.cursor = "pointer";
  }

  static void _mouseOnExit(PointerExitEvent event) {
    appContainer.style.cursor = "default";
  }
}
