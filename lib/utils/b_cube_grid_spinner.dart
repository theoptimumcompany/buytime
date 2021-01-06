import 'dart:async';

import 'package:flutter/widgets.dart';

class BCubeGridSpinner extends StatefulWidget {
  const BCubeGridSpinner({
    Key key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 900),
    this.controller,
  })  : assert(!(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null),
  'You should specify either a itemBuilder or a color'),
        assert(size != null),
        super(key: key);

  final Color color;
  final double size;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;
  final AnimationController controller;

  @override
  _BCubeGridSpinnerState createState() => _BCubeGridSpinnerState();
}

class _BCubeGridSpinnerState extends State<BCubeGridSpinner> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _anim1, _anim2, _anim3, _anim4, _anim5, _anim6, _anim7;

  bool change = false;
  Timer timer;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))
      ..repeat(reverse: true);
    _anim1 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.1, 0.3, curve: Curves.easeIn)));
    _anim2 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.4, curve: Curves.easeIn)));
    _anim3 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.5, curve: Curves.easeIn)));
    _anim4 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.6, curve: Curves.easeIn)));
    _anim5 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.7, curve: Curves.easeIn)));
    _anim6 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.8, curve: Curves.easeIn)));
    _anim7 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.7, 0.9, curve: Curves.easeIn)));
    timer = Timer.periodic(widget.duration, (timer) {
      setState(() {
        change = !change;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.square(widget.size),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _square(_anim4, 0, 1, 1),
              _square(!change ? _anim5 : _anim3, 1, 1, 2),
              _square(!change ? _anim6 : _anim2, 2, 1, 3),
              _square(!change ? _anim7 : _anim1, 3, 1, 4),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _square(!change ? _anim3 : _anim5, 4, 2, 1),
              _square(_anim4, 5, 2, 2),
              _square(!change ? _anim5 : _anim3, 6, 2, 3),
              _square(!change ?  _anim6 : _anim2, 7, 2, 4),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _square(!change ? _anim2 : _anim6, 8, 3, 1),
              _square(!change ? _anim3 :_anim5, 9, 3, 2),
              _square(_anim4, 10, 3, 3),
              _square(!change ? _anim5 : _anim3, 11, 3, 4),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _square(!change ? _anim1 : _anim7, 12, 4, 1), ///0.1 - 0.6
              _square(!change ? _anim2 : _anim6, 13, 4, 2), ///0.2 - 0.7
              _square(!change ? _anim3 : _anim5, 14, 4, 3), ///0.2 - 0.7
              _square(_anim4, 15, 4, 4), ///0.3 - 0.8
            ],
          ),
        ],
      ),
    );
  }

  Widget _square(Animation<double> animation, int index, int partY, int partX) {
    return ScaleTransition(
      scale: animation,
      child: SizedBox.fromSize(
          size: Size.square(widget.size / 4),
          child: widget.itemBuilder != null
              ? widget.itemBuilder(context, index)
              : DecoratedBox(
              decoration: BoxDecoration(
                  color: widget.color,
                  image: DecorationImage(
                      image: AssetImage('assets/img/spinner/B${partY}_$partX.png'),
                          fit: BoxFit.cover
                  )
              )
          )
      ),
    );
  }
}
/*import 'dart:async';

import 'package:flutter/widgets.dart';

class SpinKitCubeGrid extends StatefulWidget {
  const SpinKitCubeGrid({
    Key key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 700),
    this.controller,
  })  : assert(!(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null),
  'You should specify either a itemBuilder or a color'),
        assert(size != null),
        super(key: key);

  final Color color;
  final double size;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;
  final AnimationController controller;

  @override
  _SpinKitCubeGridState createState() => _SpinKitCubeGridState();
}

class _SpinKitCubeGridState extends State<SpinKitCubeGrid> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _anim1, _anim2, _anim3, _anim4, _anim5;

  bool change = false;
  Timer timer;
  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))
      ..repeat(reverse: true);
    _anim1 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.1, 0.5, )));
    _anim2 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.6,)));
    _anim3 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.7,)));
    _anim4 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.8,)));
    _anim5 = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.9, )));

    timer = Timer.periodic(widget.duration, (timer) {
      setState(() {
        change = !change;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.square(widget.size),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _square(!change ? _anim3 : _anim3, 0),
              _square(!change ? _anim4 : _anim2, 1),
              _square(!change ? _anim5 : _anim1, 2),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _square(!change ? _anim2 : _anim4, 3),
              _square(_anim3 , 4),
              _square(!change ? _anim4 : _anim2, 5),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _square(!change ? _anim1 : _anim5, 6),
              _square(!change ? _anim2 : _anim4, 7),
              _square(!change ? _anim3 : _anim3 , 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _square(Animation<double> animation, int index) {

    return ScaleTransition(
      scale: animation,
      child: SizedBox.fromSize(size: Size.square(widget.size / 3), child: _itemBuilder(index)),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder(context, index)
      : DecoratedBox(decoration: BoxDecoration(color: widget.color));
}*/

