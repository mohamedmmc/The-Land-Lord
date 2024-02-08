import 'package:flutter/material.dart';

class StickyContainer extends StatefulWidget {
  final Widget child;
  final double galleryAdditionalHeight;
  final ScrollController scrollController;

  const StickyContainer({Key? key, required this.child, required this.scrollController, required this.galleryAdditionalHeight}) : super(key: key);

  @override
  State<StickyContainer> createState() => _StickyContainerState();
}

class _StickyContainerState extends State<StickyContainer> {
  bool isSticky = false;
  double initialOffset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getInitialOffset);
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _getInitialOffset(Duration _) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      initialOffset = renderBox.localToGlobal(Offset.zero).dy + widget.galleryAdditionalHeight - 100; // AppBar height size
    }
  }

  void _scrollListener() {
    final currentOffset = widget.scrollController.offset;
    setState(() => isSticky = currentOffset > initialOffset);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
      margin: EdgeInsets.only(top: isSticky ? widget.scrollController.offset - initialOffset : 0),
      child: widget.child,
    );
  }
}
