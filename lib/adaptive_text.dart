import 'package:flutter/material.dart';

class AdaptiveTextSize {
  const AdaptiveTextSize();

  getAdaptiveTextSize(BuildContext context, dynamic value) {
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}