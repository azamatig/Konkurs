import 'package:flutter/material.dart';
import 'package:konkurs_app/utilities/arrow_clipper.dart';

class SimpleAccountMenu extends StatefulWidget {
  final List<Icon> icons;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color iconColor;
  final ValueChanged<int> onChange;
  static OverlayEntry overlayEntry;
  static bool isMenuOpen = false;
  SimpleAccountMenu({
    Key key,
    this.icons,
    this.borderRadius,
    this.backgroundColor = const Color(0xff29404E),
    this.iconColor = Colors.black,
    this.onChange,
  })  : assert(icons != null),
        super(key: key);
  @override
  _SimpleAccountMenuState createState() => _SimpleAccountMenuState();
}

class _SimpleAccountMenuState extends State<SimpleAccountMenu>
    with SingleTickerProviderStateMixin {
  GlobalKey _key;
  Offset buttonPosition;
  Size buttonSize;
  BorderRadius _borderRadius;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _borderRadius = widget.borderRadius ?? BorderRadius.circular(4);
    _key = LabeledGlobalKey("button_icon");
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
    SimpleAccountMenu.overlayEntry.remove();
    //_animationController.reverse();
    SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
  }

  void openMenu() {
    findButton();
    _animationController.forward();
    SimpleAccountMenu.overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(SimpleAccountMenu.overlayEntry);
    SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      decoration: BoxDecoration(
        color: Color(0xff102733),
        //borderRadius: _borderRadius,
      ),
      child: IconButton(
        iconSize: 28,
        icon: Icon(
         Icons.grid_view,
        ),
        color: Colors.white,
        onPressed: () {
          if (SimpleAccountMenu.isMenuOpen) {
            closeMenu();
          } else {
            openMenu();
          }
        },
      ),
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          width: buttonSize.width,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipPath(
                    clipper: ArrowClipper(),
                    child: Container(
                      width: 17,
                      height: 17,
                      color: widget.backgroundColor ?? Color(0xFFF),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    height: widget.icons.length * buttonSize.height,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: _borderRadius,
                    ),
                    child: Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(
                          color: widget.iconColor,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(widget.icons.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              widget.onChange(index);
                              closeMenu();
                            },
                            child: Container(
                              width: buttonSize.width,
                              height: buttonSize.height,
                              child: widget.icons[index],
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