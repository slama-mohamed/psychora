import 'package:flutter/material.dart';


class ResourcesSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onFocusLost;

  const ResourcesSearchBar({
    super.key,
    required this.onChanged,
    this.onFocusLost,
  });

  @override
  State<ResourcesSearchBar> createState() => _ResourcesSearchBarState();
}

class _ResourcesSearchBarState extends State<ResourcesSearchBar> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    final wasFocused = _isFocused;
    final isFocused = _focusNode.hasFocus;

    setState(() {
      _isFocused = isFocused;
    });

    // Si on perd le focus, notifier le parent
    if (wasFocused && !isFocused && widget.onFocusLost != null) {
      widget.onFocusLost!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        onTap: () => setState(() => _isFocused = true),
        onEditingComplete: () => setState(() => _isFocused = false),
        onSubmitted: (_) => setState(() => _isFocused = false),
        style: TextStyle(
          color: _isFocused ? Colors.black : Colors.grey.shade600,
        ),
        decoration: InputDecoration(
          hintText: 'Search a resource...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(
            Icons.search,
            color: _isFocused ? const Color(0xFF2E7D32) : Colors.grey.shade400,
          ),
          filled: true,
          fillColor: Colors.white, // Toujours blanc
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF2E7D32),
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}