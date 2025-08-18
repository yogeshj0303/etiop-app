import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;
  final Widget? fallback;

  const TranslatedText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.fallback,
  });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String? _translatedText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _translateText();
  }

  @override
  void didUpdateWidget(TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _translateText();
    }
  }

  Future<void> _translateText() async {
    if (widget.text.isEmpty) {
      setState(() {
        _translatedText = widget.text;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final languageProvider = context.read<LanguageProvider>();
      final translated = await languageProvider.translateApiData(widget.text);
      
      if (mounted) {
        setState(() {
          _translatedText = translated;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _translatedText = widget.text; // Fallback to original text
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.fallback ?? 
        Text(
          widget.text,
          style: widget.style,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
          softWrap: widget.softWrap,
        );
    }

    return Text(
      _translatedText ?? widget.text,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      softWrap: widget.softWrap,
    );
  }
}

class TranslatedList extends StatefulWidget {
  final List<String> texts;
  final Widget Function(BuildContext, String, int) itemBuilder;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const TranslatedList({
    super.key,
    required this.texts,
    required this.itemBuilder,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  @override
  State<TranslatedList> createState() => _TranslatedListState();
}

class _TranslatedListState extends State<TranslatedList> {
  List<String>? _translatedTexts;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _translateTexts();
  }

  @override
  void didUpdateWidget(TranslatedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.texts != widget.texts) {
      _translateTexts();
    }
  }

  Future<void> _translateTexts() async {
    if (widget.texts.isEmpty) {
      setState(() {
        _translatedTexts = widget.texts;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final languageProvider = context.read<LanguageProvider>();
      final translated = await languageProvider.translateApiDataList(widget.texts);
      
      if (mounted) {
        setState(() {
          _translatedTexts = translated;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _translatedTexts = widget.texts; // Fallback to original texts
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return ListView.builder(
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        padding: widget.padding,
        itemCount: widget.texts.length,
        itemBuilder: (context, index) => widget.itemBuilder(
          context, 
          widget.texts[index], 
          index
        ),
      );
    }

    final textsToUse = _translatedTexts ?? widget.texts;
    
    return ListView.builder(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      padding: widget.padding,
      itemCount: textsToUse.length,
      itemBuilder: (context, index) => widget.itemBuilder(
        context, 
        textsToUse[index], 
        index
      ),
    );
  }
}
