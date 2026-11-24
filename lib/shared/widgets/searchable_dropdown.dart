import 'package:flutter/material.dart';

/// An advanced, customizable, searchable dropdown widget for enterprise Flutter apps.
/// Works seamlessly with form validation, supports large data lists, search filtering,
/// custom item rendering, light/dark themes, and modal bottom sheets.
class SearchableDropdown<T> extends FormField<T> {
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String Function(T item) itemLabel;
  final String Function(T item)? itemSubtitle;
  final Widget Function(T item)? itemIcon;
  final bool Function(T item, String query)? searchMatcher;
  final String? labelText;
  final String? hintText;
  final String? searchHintText;
  final String? modalTitle;
  final Widget? prefixIcon;
  final bool allowClear;
  final InputDecoration? decoration;

  SearchableDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    required this.itemLabel,
    this.itemSubtitle,
    this.itemIcon,
    this.searchMatcher,
    this.labelText,
    this.hintText,
    this.searchHintText,
    this.modalTitle,
    this.prefixIcon,
    super.enabled = true,
    this.allowClear = false,
    this.decoration,
    super.validator,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
  }) : super(
         initialValue: value,
         builder: (FormFieldState<T> field) {
           final _SearchableDropdownState<T> state =
               field as _SearchableDropdownState<T>;
           return state._buildDropdown(field.context);
         },
       );

  @override
  FormFieldState<T> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends FormFieldState<T> {
  @override
  SearchableDropdown<T> get widget => super.widget as SearchableDropdown<T>;

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setValue(widget.value);
    }
  }

  void _handleSelect(T? selectedItem) {
    setValue(selectedItem);
    if (widget.onChanged != null) {
      widget.onChanged!(selectedItem);
    }
  }

  Widget _buildDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;
    final selectedItem = value;
    final isEnabled = widget.enabled;

    final effectiveDecoration =
        (widget.decoration ??
                InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText ?? "Select an option",
                  prefixIcon: widget.prefixIcon,
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isDark ? Colors.white30 : Colors.black26,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ))
            .copyWith(
              hintText:
                  widget.hintText ?? widget.labelText ?? "Select an option",
              errorText: errorText,
              enabled: isEnabled,
            );

    final displayString = selectedItem != null
        ? widget.itemLabel(selectedItem)
        : null;

    return InkWell(
      onTap: isEnabled ? () => _openSearchModal(context) : null,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: effectiveDecoration,
        isEmpty: selectedItem == null,
        child: selectedItem != null
            ? Row(
                children: [
                  if (widget.itemIcon != null) ...[
                    widget.itemIcon!(selectedItem),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      displayString!,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.allowClear && isEnabled)
                    GestureDetector(
                      onTap: () => _handleSelect(null),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(
                          Icons.cancel_rounded,
                          size: 18,
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                      ),
                    ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: isEnabled
                        ? (isDark ? Colors.white70 : Colors.black54)
                        : (isDark ? Colors.white24 : Colors.black26),
                    size: 28,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: isEnabled
                        ? (isDark ? Colors.white70 : Colors.black54)
                        : (isDark ? Colors.white24 : Colors.black26),
                    size: 28,
                  ),
                ],
              ),
      ),
    );
  }

  void _openSearchModal(BuildContext context) {
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return _SearchDropdownModal<T>(
          items: widget.items,
          selectedValue: value,
          itemLabel: widget.itemLabel,
          itemSubtitle: widget.itemSubtitle,
          itemIcon: widget.itemIcon,
          searchMatcher: widget.searchMatcher,
          searchHintText: widget.searchHintText,
          modalTitle: widget.modalTitle ?? widget.labelText ?? "Select Option",
          allowClear: widget.allowClear,
        );
      },
    ).then((selected) {
      if (selected != null) {
        _handleSelect(selected);
      }
    });
  }
}

class _SearchDropdownModal<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedValue;
  final String Function(T item) itemLabel;
  final String Function(T item)? itemSubtitle;
  final Widget Function(T item)? itemIcon;
  final bool Function(T item, String query)? searchMatcher;
  final String? searchHintText;
  final String modalTitle;
  final bool allowClear;

  const _SearchDropdownModal({
    required this.items,
    required this.selectedValue,
    required this.itemLabel,
    this.itemSubtitle,
    this.itemIcon,
    this.searchMatcher,
    this.searchHintText,
    required this.modalTitle,
    required this.allowClear,
  });

  @override
  State<_SearchDropdownModal<T>> createState() =>
      _SearchDropdownModalState<T>();
}

class _SearchDropdownModalState<T> extends State<_SearchDropdownModal<T>> {
  final TextEditingController _searchController = TextEditingController();
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.items);
      } else {
        _filteredItems = widget.items.where((item) {
          if (widget.searchMatcher != null) {
            return widget.searchMatcher!(item, query);
          }
          final label = widget.itemLabel(item).toLowerCase();
          final subtitle = widget.itemSubtitle != null
              ? widget.itemSubtitle!(item).toLowerCase()
              : "";
          final q = query.toLowerCase();
          return label.contains(q) || subtitle.contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle indicator
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.modalTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${_filteredItems.length} of ${widget.items.length} options",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.searchHintText ?? "Search options...",
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF2A2A3D) : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),

          // List of items
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 56,
                            color: isDark ? Colors.white30 : Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No matching options",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Try searching with a different keyword",
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white38 : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = widget.selectedValue == item;
                      final label = widget.itemLabel(item);
                      final subtitle = widget.itemSubtitle != null
                          ? widget.itemSubtitle!(item)
                          : null;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Material(
                          color: isSelected
                              ? primaryColor.withValues(
                                  alpha: isDark ? 0.25 : 0.12,
                                )
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: widget.itemIcon != null
                                ? widget.itemIcon!(item)
                                : isSelected
                                ? Icon(
                                    Icons.check_circle_rounded,
                                    color: primaryColor,
                                  )
                                : const Icon(
                                    Icons.radio_button_unchecked_rounded,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                            title: Text(
                              label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? (isDark ? Colors.white : primaryColor)
                                    : (isDark
                                          ? Colors.white70
                                          : Colors.black87),
                              ),
                            ),
                            subtitle: subtitle != null
                                ? Text(
                                    subtitle,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected
                                          ? (isDark
                                                ? Colors.white70
                                                : primaryColor.withValues(
                                                    alpha: 0.8,
                                                  ))
                                          : (isDark
                                                ? Colors.white54
                                                : Colors.grey[600]),
                                    ),
                                  )
                                : null,
                            trailing: isSelected && widget.itemIcon != null
                                ? Icon(
                                    Icons.check_rounded,
                                    color: primaryColor,
                                    size: 20,
                                  )
                                : null,
                            onTap: () {
                              Navigator.pop(context, item);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
