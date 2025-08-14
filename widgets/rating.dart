import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A customizable star rating widget with interactive capabilities
/// 
/// Usage:
/// ```dart
/// PlumerRating(
///   rating: 4.5,
///   starCount: 5,
///   onRatingChanged: (rating) => print('Rating: $rating'),
///   allowHalfRating: true,
/// )
/// ```
class PlumerRating extends StatefulWidget {
  final double rating;
  final int starCount;
  final ValueChanged<double>? onRatingChanged;
  final bool allowHalfRating;
  final bool readOnly;
  final double starSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final IconData? starIcon;
  final IconData? halfStarIcon;
  final double spacing;
  final MainAxisAlignment alignment;

  const PlumerRating({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.onRatingChanged,
    this.allowHalfRating = true,
    this.readOnly = false,
    this.starSize = 24.0,
    this.activeColor,
    this.inactiveColor,
    this.starIcon,
    this.halfStarIcon,
    this.spacing = 4.0,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  State<PlumerRating> createState() => _PlumerRatingState();
}

class _PlumerRatingState extends State<PlumerRating> {
  double _currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  void didUpdateWidget(PlumerRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rating != widget.rating) {
      _currentRating = widget.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? Colors.amber;
    final inactiveColor = widget.inactiveColor ?? theme.colorScheme.outline.withOpacity(0.3);

    return Row(
      mainAxisAlignment: widget.alignment,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (index) {
        return GestureDetector(
          onTap: widget.readOnly ? null : () => _onStarTap(index),
          onPanUpdate: widget.readOnly ? null : (details) => _onPanUpdate(details, index),
          child: Container(
            margin: EdgeInsets.only(right: index < widget.starCount - 1 ? widget.spacing : 0),
            child: _buildStar(index, activeColor, inactiveColor),
          ),
        );
      }),
    );
  }

  Widget _buildStar(int index, Color activeColor, Color inactiveColor) {
    final starValue = index + 1.0;
    final difference = _currentRating - index;
    
    if (difference >= 1.0) {
      // Full star
      return Icon(
        widget.starIcon ?? Icons.star,
        size: widget.starSize,
        color: activeColor,
      );
    } else if (difference > 0.0 && widget.allowHalfRating) {
      // Half star
      return Stack(
        children: [
          Icon(
            widget.starIcon ?? Icons.star,
            size: widget.starSize,
            color: inactiveColor,
          ),
          ClipRect(
            clipper: _HalfStarClipper(difference),
            child: Icon(
              widget.halfStarIcon ?? widget.starIcon ?? Icons.star,
              size: widget.starSize,
              color: activeColor,
            ),
          ),
        ],
      );
    } else {
      // Empty star
      return Icon(
        widget.starIcon ?? Icons.star,
        size: widget.starSize,
        color: inactiveColor,
      );
    }
  }

  void _onStarTap(int index) {
    final newRating = (index + 1).toDouble();
    _updateRating(newRating);
  }

  void _onPanUpdate(DragUpdateDetails details, int index) {
    if (!widget.allowHalfRating) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    final starWidth = widget.starSize + widget.spacing;
    final relativeX = localPosition.dx - (index * starWidth);
    
    double newRating;
    if (relativeX <= widget.starSize / 2) {
      newRating = index + 0.5;
    } else {
      newRating = index + 1.0;
    }
    
    newRating = newRating.clamp(0.0, widget.starCount.toDouble());
    _updateRating(newRating);
  }

  void _updateRating(double rating) {
    if (rating != _currentRating) {
      setState(() {
        _currentRating = rating;
      });
      widget.onRatingChanged?.call(rating);
    }
  }
}

/// Custom clipper for half stars
class _HalfStarClipper extends CustomClipper<Rect> {
  final double fillPercentage;

  _HalfStarClipper(this.fillPercentage);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fillPercentage, size.height);
  }

  @override
  bool shouldReclip(_HalfStarClipper oldClipper) {
    return oldClipper.fillPercentage != fillPercentage;
  }
}

/// A comprehensive review widget with rating, author, and content
/// 
/// Usage:
/// ```dart
/// PlumerReview(
///   author: 'John Doe',
///   authorAvatar: 'https://example.com/avatar.jpg',
///   rating: 4.5,
///   title: 'Great product!',
///   content: 'I love this product...',
///   timestamp: DateTime.now(),
/// )
/// ```
class PlumerReview extends StatelessWidget {
  final String author;
  final String? authorAvatar;
  final double rating;
  final String? title;
  final String content;
  final DateTime? timestamp;
  final List<String>? images;
  final bool verified;
  final int? helpfulCount;
  final VoidCallback? onHelpful;
  final VoidCallback? onReport;
  final EdgeInsetsGeometry? padding;
  final bool showActions;

  const PlumerReview({
    super.key,
    required this.author,
    this.authorAvatar,
    required this.rating,
    this.title,
    required this.content,
    this.timestamp,
    this.images,
    this.verified = false,
    this.helpfulCount,
    this.onHelpful,
    this.onReport,
    this.padding,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 12),
            PlumerRating(
              rating: rating,
              readOnly: true,
              starSize: 16,
              activeColor: Colors.amber,
            ),
            if (title != null) ...[
              const SizedBox(height: 8),
              Text(
                title!,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            if (images != null && images!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildImageGallery(context),
            ],
            if (showActions) ...[
              const SizedBox(height: 16),
              _buildActions(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: authorAvatar != null ? NetworkImage(authorAvatar!) : null,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: authorAvatar == null
              ? Icon(
                  Icons.person,
                  color: theme.colorScheme.onPrimaryContainer,
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    author,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (verified) ...[
                    const SizedBox(width: 6),
                    Icon(
                      Icons.verified,
                      size: 16,
                      color: Colors.blue,
                    ),
                  ],
                ],
              ),
              if (timestamp != null)
                Text(
                  _formatTimestamp(timestamp!),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          onPressed: onReport,
          icon: Icon(
            Icons.more_vert,
            size: 20,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  Widget _buildImageGallery(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images!.length,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.network(
                images![index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.image,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions(ThemeData theme) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: onHelpful,
          icon: Icon(
            Icons.thumb_up_outlined,
            size: 16,
          ),
          label: Text(helpfulCount != null ? 'Helpful (${helpfulCount})' : 'Helpful'),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurface.withOpacity(0.7),
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: onReport,
          icon: Icon(
            Icons.flag_outlined,
            size: 16,
          ),
          label: Text('Report'),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurface.withOpacity(0.7),
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 30) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

/// A compact rating summary widget showing distribution
/// 
/// Usage:
/// ```dart
/// PlumerRatingSummary(
///   averageRating: 4.2,
///   totalReviews: 150,
///   ratingDistribution: {5: 80, 4: 40, 3: 20, 2: 8, 1: 2},
/// )
/// ```
class PlumerRatingSummary extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;
  final bool showDistribution;
  final double maxBarWidth;

  const PlumerRatingSummary({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    this.showDistribution = true,
    this.maxBarWidth = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlumerRating(
                      rating: averageRating,
                      readOnly: true,
                      starSize: 20,
                      activeColor: Colors.amber,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalReviews reviews',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (showDistribution) ...[
              const SizedBox(height: 16),
              _buildRatingDistribution(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRatingDistribution(ThemeData theme) {
    final maxCount = ratingDistribution.values.isNotEmpty
        ? ratingDistribution.values.reduce(math.max)
        : 1;

    return Column(
      children: [
        for (int rating = 5; rating >= 1; rating--)
          _buildRatingBar(theme, rating, ratingDistribution[rating] ?? 0, maxCount),
      ],
    );
  }

  Widget _buildRatingBar(ThemeData theme, int rating, int count, int maxCount) {
    final percentage = maxCount > 0 ? count / maxCount : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$rating',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.star,
            size: 16,
            color: Colors.amber,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

/// A quick rating input widget
/// 
/// Usage:
/// ```dart
/// PlumerQuickRating(
///   title: 'How was your experience?',
///   onRatingSubmitted: (rating, comment) {
///     print('Rating: $rating, Comment: $comment');
///   },
/// )
/// ```
class PlumerQuickRating extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final ValueChanged<double>? onRatingChanged;
  final Function(double rating, String? comment)? onRatingSubmitted;
  final bool showCommentField;
  final String? submitButtonText;
  final String? commentHint;
  final double initialRating;

  const PlumerQuickRating({
    super.key,
    this.title,
    this.subtitle,
    this.onRatingChanged,
    this.onRatingSubmitted,
    this.showCommentField = true,
    this.submitButtonText,
    this.commentHint,
    this.initialRating = 0.0,
  });

  @override
  State<PlumerQuickRating> createState() => _PlumerQuickRatingState();
}

class _PlumerQuickRatingState extends State<PlumerQuickRating> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null)
              Text(
                widget.title!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Center(
              child: PlumerRating(
                rating: _rating,
                starSize: 32,
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                  widget.onRatingChanged?.call(rating);
                },
              ),
            ),
            if (_rating > 0) ...[
              const SizedBox(height: 16),
              if (widget.showCommentField) ...[
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: widget.commentHint ?? 'Add a comment (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onRatingSubmitted?.call(
                      _rating,
                      _commentController.text.isNotEmpty ? _commentController.text : null,
                    );
                  },
                  child: Text(widget.submitButtonText ?? 'Submit Rating'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}