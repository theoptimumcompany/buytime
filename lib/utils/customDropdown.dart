import 'package:Buytime/UI/user/login/UI_U_Login.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/utils/arrowClipper.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutoCompleteMenu extends StatefulWidget {
  final List<AutoCompleteState> items;
  //final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final ValueChanged<int> onChange;
  OverlayEntry overlayEntry;
  //final int type;

  AutoCompleteMenu({
    Key key,
    this.items,
    this.iconColor,
    this.backgroundColor,
    this.textColor,
    this.onChange,
    this.overlayEntry
  })  : assert(items != null),
        super(key: key);
  @override
  _AutoCompleteMenuState createState() => _AutoCompleteMenuState();
}

String strPrefix = '';
String strCountry = '';

class _AutoCompleteMenuState extends State<AutoCompleteMenu> with SingleTickerProviderStateMixin {
  GlobalKey _key;
  Offset buttonPosition;
  Size buttonSize;
  OverlayEntry _overlayEntry;
  AnimationController _animationController;

  String hint;


  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _key = LabeledGlobalKey("button_icon");
    hint = '';
    //hint = widget.type == 0  ? strPrefix.isEmpty ? 'Prefix' : strPrefix : strCountry.isEmpty ? 'Country' : strCountry;
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    if(widget.items.isNotEmpty){
      overlayEntry.remove();
      _animationController.reverse();
      isMenuOpen = !isMenuOpen;
    }
  }

  void openMenu() {
    if(widget.items.isNotEmpty){
      findButton();
      _animationController.forward();
      overlayEntry = _overlayEntryBuilder();
      Overlay.of(context).insert(overlayEntry);
      isMenuOpen = !isMenuOpen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //margin: EdgeInsets.only(right: .5),
        key: _key,
        decoration: BoxDecoration(
          //color: Colors.blue,
          //borderRadius: _borderRadius,
        ),
        child: IconButton(
          icon: Icon(
            Icons.lock,
            //progress: _animationController,
          ),
          color: widget.items.isEmpty ? BuytimeTheme.TextMedium : BuytimeTheme.ButtonMalibu,
          onPressed: widget.items.isNotEmpty ? () {
            if (isMenuOpen) {
              closeMenu();
            } else {
              openMenu();
            }
          } : null,
        )
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx - 268,
          width: 300,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                widget.items.isNotEmpty ? Align(
                  alignment: Alignment.topRight,
                  child: ClipPath(
                    clipper: ArrowClipper(),
                    child: Container(
                      width: 17,
                      height: 17,
                      color: BuytimeTheme.ButtonMalibu,
                    ),
                  ),
                ) : Container(),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    height: widget.items.length * (buttonSize.height + 10),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      border: Border.all(
                          color: BuytimeTheme.ButtonMalibu,
                        width: 2
                      ),
                      borderRadius: BorderRadius.all(
                        const Radius.circular(5.0),
                      ),
                    ),
                    child: Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(
                          color: widget.textColor,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                            widget.items.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              widget.onChange(index);
                              /*setState(() {
                                if(widget.type == 0) {
                                  strPrefix = widget.icons[index];
                                  print(strPrefix.substring(strPrefix.length-4, strPrefix.length-1));
                                }else
                                  strCountry = widget.icons[index];

                                hint = widget.icons[index];
                              });*/
                              closeMenu();
                            },
                            child: Container(
                                width: 300,
                                height: buttonSize.height + 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    ///Email Icon & Email
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ///Email Icon
                                        Container(
                                          margin: EdgeInsets.only(left: 10.0, top: 0),
                                          child: Icon(
                                            Icons.email,
                                            color: BuytimeTheme.ButtonMalibu,
                                          ),
                                        ),
                                        ///Email
                                        Container(
                                          margin: EdgeInsets.only(left: 10.0, top: 0),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child:  Text(
                                              '${widget.items[index].email}',
                                              style: TextStyle(
                                                  color: widget.textColor,
                                                  fontWeight: FontWeight.w600
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ///Buytime Logo
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0, top: 0),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/img/img_buytime.png'),
                                          )
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}