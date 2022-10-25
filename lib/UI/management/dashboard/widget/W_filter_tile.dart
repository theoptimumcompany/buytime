import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/cupertino.dart';

class WFilterTile extends StatefulWidget {

  bool selected;
  String filterType;
  WFilterTile(this.filterType, this.selected);

  @override
  State<WFilterTile> createState() => _WFilterTileState();
}

class _WFilterTileState extends State<WFilterTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 23,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: widget.selected ? BuytimeTheme.SymbolGrey.withOpacity(.7) : BuytimeTheme.SymbolLightGrey.withOpacity(.5),
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Text(
        widget.filterType,
        style: TextStyle(
            fontFamily: BuytimeTheme.FontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}