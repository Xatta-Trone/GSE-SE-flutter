import 'dart:async';

import 'package:flutter/material.dart';

mixin DebounceMixin {
  //  debounce
  Timer? _debounce;

  void handleDebounce(VoidCallback function) {
    if (_debounce != null) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // not call the search method
      function();
    });
  }
}
