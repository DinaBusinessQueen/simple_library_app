import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../services/user_service.dart';

class BookmarkButton extends StatefulWidget {
  final Book book;
  final Color? activeColor;
  final Color? inactiveColor;
  final double size;

  const BookmarkButton({
    Key? key,
    required this.book,
    this.activeColor,
    this.inactiveColor,
    this.size = 24,
  }) : super(key: key);

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This ensures we update the status when the dependencies (like UserService) change
    _checkIfFavorite();
  }

  @override
  void didUpdateWidget(BookmarkButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the book ID changes, we need to update the favorite status
    if (oldWidget.book.id != widget.book.id) {
      _checkIfFavorite();
    }
  }

  Future<void> _checkIfFavorite() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userService = Provider.of<UserService>(context, listen: false);
      final isFavorite = await userService.isBookFavorite(widget.book.id);

      if (mounted) {
        setState(() {
          _isFavorite = isFavorite;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userService = Provider.of<UserService>(context, listen: false);
      await userService.toggleFavorite(widget.book);

      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
          _isLoading = false;
        });
      }

      // Show a snackbar
      final message =
          _isFavorite
              ? '${widget.book.title} added to favorites'
              : '${widget.book.title} removed from favorites';
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes in the UserService
    final userService = Provider.of<UserService>(context);
    final activeColor = widget.activeColor ?? Colors.red;
    final inactiveColor = widget.inactiveColor ?? Colors.grey;

    // If the book is in the favorites list, update the local state
    if (userService.favoriteBooks.any((book) => book.id == widget.book.id) !=
            _isFavorite &&
        !_isLoading) {
      Future.microtask(() => _checkIfFavorite());
    }

    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? activeColor : inactiveColor,
        size: widget.size,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
