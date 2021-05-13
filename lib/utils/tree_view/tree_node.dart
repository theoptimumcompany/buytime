import 'dart:math' show pi;

import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/tree_view/tree_view.dart';
import 'package:Buytime/utils/tree_view/tree_view_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'expander_theme_data.dart';
import 'models/node.dart';

const double _kBorderWidth = 0.75;

/// Defines the [TreeNode] widget.
///
/// This widget is used to display a tree node and its children. It requires
/// a single [Node] value. It uses this node to display the state of the
/// widget. It uses the [TreeViewTheme] to handle the appearance and the
/// [TreeView] properties to handle to user actions.
///
/// __This class should not be used directly!__
/// The [TreeView] and [TreeViewController] handlers the data and rendering
/// of the nodes.
class TreeNode extends StatefulWidget {
  /// The node object used to display the widget state
  final Node node;

  const TreeNode({Key key, @required this.node}) : super(key: key);

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
  CurveTween(curve: Curves.easeIn);
  static double _kIconSize = 28;

  AnimationController _controller;
  Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _isExpanded = widget.node.expanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TreeView _treeView = TreeView.of(context);
    _controller.duration = _treeView.theme.expandSpeed;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TreeNode oldWidget) {
    if (widget.node.expanded != oldWidget.node.expanded) {
      setState(() {
        _isExpanded = widget.node.expanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((void value) {
            if (!mounted) return;
            setState(() {});
          });
        }
      });
    } else if (widget.node != oldWidget.node) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleExpand() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {});
        });
      }
    });
    if (_treeView.onExpansionChanged != null)
      _treeView.onExpansionChanged(widget.node.key, _isExpanded);
  }

  void _handleTap() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    if (_treeView.onNodeTap != null) {
      _treeView.onNodeTap(widget.node.key);
    }
  }

  void _handleDoubleTap() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    if (_treeView.onNodeDoubleTap != null) {
      _treeView.onNodeDoubleTap(widget.node.key);
    }
  }

  Widget _buildNodeExpander() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    return widget.node.isParent
        ? GestureDetector(
      onTap: () => _handleExpand(),
      child: _TreeNodeExpander(
        speed: _controller.duration,
        expanded: widget.node.expanded,
        themeData: _theme.expanderTheme,
      ),
    )
        : Container(
      width: 10,
    );
  }

  Widget _buildNodeIcon() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    bool isSelected = _treeView.controller.selectedKey != null &&
        _treeView.controller.selectedKey == widget.node.key;
    return Container(
      alignment: Alignment.center,
      width:
      widget.node.hasIcon ? _theme.iconTheme.size + _theme.iconPadding : 0,
      child: widget.node.hasIcon
          ? Icon(
        widget.node.icon,
        size: _theme.iconTheme.size,
        color: isSelected
            ? _theme.colorScheme.onPrimary
            : _theme.iconTheme.color,
      )
          : null,
    );
  }

  Widget _buildNodeLabel() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    bool isSelected = _treeView.controller.selectedKey != null &&
        _treeView.controller.selectedKey == widget.node.key;
    final icon = _buildNodeIcon();
    return widget.node.bg.isNotEmpty ?
    CachedNetworkImage(
      imageUrl: widget.node.bg,
      imageBuilder: (context, imageProvider) => Container(
        margin: EdgeInsets.only(bottom: 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover
            )
        ) ,
        child: Container(
          padding: EdgeInsets.only(top: 15, bottom: 15,),
          decoration: BoxDecoration(
              color: BuytimeTheme.BackgroundBlack.withOpacity(0.4),
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10.0, right: 5.0),
                        child: icon,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        /*decoration: BoxDecoration(
                          color: BuytimeTheme.BackgroundBlack.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),*/
                        child: Text(
                          widget.node.label,
                          softWrap: widget.node.isParent
                              ? _theme.parentLabelOverflow == null
                              : _theme.labelOverflow == null,
                          overflow: widget.node.isParent
                              ? _theme.parentLabelOverflow
                              : _theme.labelOverflow,
                          style: widget.node.isParent
                              ? _theme.parentLabelStyle.copyWith(
                            fontWeight: _theme.parentLabelStyle.fontWeight,
                            color: isSelected
                                ? _theme.colorScheme.onPrimary
                                : _theme.parentLabelStyle.color,
                          )
                              : _theme.labelStyle.copyWith(
                            fontWeight: _theme.labelStyle.fontWeight,
                            color: isSelected ? _theme.colorScheme.onPrimary : null,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 30,
                    //padding: EdgeInsets.all(0),
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: widget.node.actionIcon,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        margin: EdgeInsets.only(right: 0, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              //valueColor: new AlwaysStoppedAnimation<Color>(BuytimeTheme.ManagerPrimary.withOpacity(0.5)),
            )
          ],
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    )
    : Container(
      margin: EdgeInsets.only(bottom: 0),
      decoration: widget.node.bg.isNotEmpty ? BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(
              image: NetworkImage(widget.node.bg),
              fit: BoxFit.cover
          )
      ) : BoxDecoration(
          color: BuytimeTheme.BackgroundWhite
      ),
      child: Container(
        padding: EdgeInsets.only(top: 15, bottom: 15,),
        decoration: BoxDecoration(
            color: BuytimeTheme.BackgroundBlack.withOpacity(0.4),
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10.0, right: 5.0),
                      child: icon,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      /*decoration: BoxDecoration(
                          color: BuytimeTheme.BackgroundBlack.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),*/
                      child: Text(
                        widget.node.label,
                        softWrap: widget.node.isParent
                            ? _theme.parentLabelOverflow == null
                            : _theme.labelOverflow == null,
                        overflow: widget.node.isParent
                            ? _theme.parentLabelOverflow
                            : _theme.labelOverflow,
                        style: widget.node.isParent
                            ? _theme.parentLabelStyle.copyWith(
                          fontWeight: _theme.parentLabelStyle.fontWeight,
                          color: isSelected
                              ? _theme.colorScheme.onPrimary
                              : _theme.parentLabelStyle.color,
                        )
                            : _theme.labelStyle.copyWith(
                          fontWeight: _theme.labelStyle.fontWeight,
                          color: isSelected ? _theme.colorScheme.onPrimary : null,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  width: 30,
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: widget.node.actionIcon,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeWidget() {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView.theme;
    bool isSelected = _treeView.controller.selectedKey != null &&
        _treeView.controller.selectedKey == widget.node.key;
    bool canSelectParent = _treeView.allowParentSelect;
    final arrowContainer = _buildNodeExpander();
    final labelContainer = _treeView.nodeBuilder != null
        ? _treeView.nodeBuilder(context, widget.node)
        : _buildNodeLabel();
    Widget _tappable = _treeView.onNodeDoubleTap != null
        ? InkWell(
      hoverColor: Colors.blue,
      onTap: _handleTap,
      onDoubleTap: _handleDoubleTap,
      child: labelContainer,
    )
        : InkWell(
      hoverColor: Colors.blue,
      onTap: _handleTap,
      child: labelContainer,
    );
    if (widget.node.isParent) {
      if (_treeView.supportParentDoubleTap && canSelectParent) {
        _tappable = Container(
          padding: EdgeInsets.only(bottom: 5.0, left: 10),
          child: InkWell(
            onTap: canSelectParent ? _handleTap : _handleExpand,
            onDoubleTap: () {
              _handleExpand();
              _handleDoubleTap();
            },
            child: labelContainer,
          ),
        );
      } else if (_treeView.supportParentDoubleTap) {
        _tappable = InkWell(
          onTap: _handleExpand,
          onDoubleTap: _handleDoubleTap,
          child: labelContainer,
        );
      } else {
        _tappable = Container(
          padding: EdgeInsets.only(bottom: 5.0, left: 10),
          child: InkWell(
            onTap: canSelectParent ? _handleTap : _handleExpand,
            child: labelContainer,
          ),
        );
      }
    }
    return Container(
      color: isSelected ? _theme.colorScheme.primary : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _theme.expanderTheme.position == ExpanderPosition.end ?
        <Widget>[
          Expanded(
            child: _tappable,
          ),
          arrowContainer,
        ] : <Widget>[
          Container(
            //padding: EdgeInsets.only(bottom: 5.0, left: 10),
            child: arrowContainer,
          ),
          Expanded(
            child: _tappable,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TreeView _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    final bool closed =
        (!_isExpanded || !widget.node.expanded) && _controller.isDismissed;
    final nodeWidget = _buildNodeWidget();
    return widget.node.isParent
        ? AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            nodeWidget,
            ClipRect(
              child: Align(
                heightFactor: _heightFactor.value,
                child: child,
              ),
            ),
          ],
        );
      },
      child: closed
          ? null
          : Container(
        margin: EdgeInsets.only(
            left: _treeView.theme.horizontalSpacing ??
                _treeView.theme.iconTheme.size),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.node.children.map((Node node) {
              return Container(
                  padding: EdgeInsets.only(top: 0.0, left: 0),
                  child: TreeNode(node: node)
              );
            }).toList()),
      ),
    )
        : Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 5.0, left: 10),
            child: nodeWidget,
          ),
          /*Container(
                  color: BuytimeTheme.ManagerPrimary.withOpacity(0.3),
                  margin: EdgeInsets.only(left: 48.0, top: 0),
                  height: 1,
                )*/
        ],
      ),
    );
  }
}

class _TreeNodeExpander extends StatefulWidget {
  final ExpanderThemeData themeData;
  final bool expanded;
  final Duration _expandSpeed;

  const _TreeNodeExpander({
    Duration speed,
    this.themeData,
    this.expanded,
  }) : _expandSpeed = speed;

  @override
  _TreeNodeExpanderState createState() => _TreeNodeExpanderState();
}

class _TreeNodeExpanderState extends State<_TreeNodeExpander>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    bool isEnd = widget.themeData.position == ExpanderPosition.end;
    if (widget.themeData.type != ExpanderType.plusMinus) {
      controller = AnimationController(
        duration: widget.themeData.animated
            ? isEnd
            ? widget._expandSpeed * 0.625
            : widget._expandSpeed
            : Duration(milliseconds: 0),
        vsync: this,
      );
      animation = Tween<double>(
        begin: 0,
        end: isEnd ? 180 : 90,
      ).animate(controller);
    } else {
      controller =
          AnimationController(duration: Duration(milliseconds: 0), vsync: this);
      animation = Tween<double>(begin: 0, end: 0).animate(controller);
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_TreeNodeExpander oldWidget) {
    if (widget.themeData != oldWidget.themeData ||
        widget.expanded != oldWidget.expanded) {
      bool isEnd = widget.themeData.position == ExpanderPosition.end;
      setState(() {
        if (widget.themeData.type != ExpanderType.plusMinus) {
          controller.duration = widget.themeData.animated
              ? isEnd
              ? widget._expandSpeed * 0.625
              : widget._expandSpeed
              : Duration(milliseconds: 0);
          animation = Tween<double>(
            begin: 0,
            end: isEnd ? 180 : 90,
          ).animate(controller);
        } else {
          controller.duration = Duration(milliseconds: 0);
          animation = Tween<double>(begin: 0, end: 0).animate(controller);
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  Color _onColor(Color color) {
    if (color != null) {
      if (color.computeLuminance() > 0.6) {
        return Colors.black;
      } else {
        return Colors.white;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    IconData _arrow;
    double _iconSize = widget.themeData.size;
    double _borderWidth = 0;
    BoxShape _shapeBorder = BoxShape.rectangle;
    Color _backColor = Colors.transparent;
    Color _iconColor =
        widget.themeData.color ?? Theme.of(context).iconTheme.color;
    switch (widget.themeData.modifier) {
      case ExpanderModifier.none:
        break;
      case ExpanderModifier.circleFilled:
        _shapeBorder = BoxShape.circle;
        _backColor = widget.themeData.color ?? Colors.black;
        _iconColor = _onColor(_backColor);
        break;
      case ExpanderModifier.circleOutlined:
        _borderWidth = _kBorderWidth;
        _shapeBorder = BoxShape.circle;
        break;
      case ExpanderModifier.squareFilled:
        _backColor = widget.themeData.color ?? Colors.black;
        _iconColor = _onColor(_backColor);
        break;
      case ExpanderModifier.squareOutlined:
        _borderWidth = _kBorderWidth;
        break;
    }
    switch (widget.themeData.type) {
      case ExpanderType.chevron:
        _arrow = Icons.expand_less;
        break;
      case ExpanderType.arrow:
        _arrow = Icons.arrow_downward;
        _iconSize = widget.themeData.size > 20
            ? widget.themeData.size - 8
            : widget.themeData.size;
        break;
      case ExpanderType.caret:
        _arrow = Icons.arrow_drop_down;
        break;
      case ExpanderType.plusMinus:
        _arrow = widget.expanded ? Icons.remove : Icons.add;
        break;
    }

    Icon _icon = Icon(
      _arrow,
      size: _iconSize,
      color: _iconColor,
    );

    if (widget.expanded) {
      controller.reverse();
    } else {
      controller.forward();
    }
    return Container(
      width: widget.themeData.size + 2,
      height: widget.themeData.size + 2,
      margin: EdgeInsets.only(left: 5.0, right: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: _shapeBorder,
        border: _borderWidth == 0
            ? null
            : Border.all(
          width: _borderWidth,
          color: widget.themeData.color ?? Colors.black,
        ),
        color: _backColor,
      ),
      child: AnimatedBuilder(
        animation: controller,
        child: _icon,
        builder: (context, child) {
          return Transform.rotate(
            angle: animation.value * (-pi / 180),
            child: child,
          );
        },
      ),
    );
  }
}
