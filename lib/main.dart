/*
* 仿写知识点：
* 1、原始指针事件处理
* 2、手势识别-点击、双击、长按
* 3、手势识别-拖动、滑动、单一方向拖动
* 4、手势识别-点击事件处理
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

main() => runApp(WBLMaterialApp());

class WBLMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WBLHome(),
    );
  }
}

class WBLHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "实验4_3",
        ),
      ),
      body: WBLBody(),
    );
  }
}

//WBLBody前不加_，暴露给其它人使用
class WBLBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return functionSelection();
  }
}

class functionSelection extends StatelessWidget {
  //功能选择
  //按钮函数
  Widget functionButton(BuildContext context, String text, Widget func) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              textStyle: TextStyle(
                fontSize: 22,
              ),
              minimumSize: Size(300, 60)),
          child: Text(text),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return NewRoute(func);
              }),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        functionButton(context, '原始指针事件处理', PointerMoveIndicator()),
        SizedBox(
          height: 20,
        ), //使上下之间有间距
        functionButton(context, '手势识别-点击、双击、长按', GestureTest()),
        SizedBox(
          height: 20,
        ), //使上下之间有间距
        functionButton(context, '手势识别-拖动、滑动', Drag()),
        SizedBox(
          height: 20,
        ), //使上下之间有间距
        functionButton(context, '手势识别-竖向方向拖动', DragVertical()),
        SizedBox(
          height: 20,
        ), //使上下之间有间距
        functionButton(context, '手势识别-点击事件处理', _GestureRecognizer()),
      ],
    );
  }
}

class NewRoute extends StatelessWidget {
  late Widget func;

  NewRoute(Widget func) : super() {
    this.func = func;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: Text(""),
          ),
      body: Center(
        child: func,
      ),
    );
  }
}

class PointerMoveIndicator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PointerMoveIndicatorState();
  }
}

class _PointerMoveIndicatorState extends State<PointerMoveIndicator> {
  //原始指针事件处理
  PointerEvent? _event;

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: Container(
        alignment: Alignment.center,
        color: Colors.blue,
        width: 300.0,
        height: 150.0,
        child: Text(
          '${_event?.localPosition ?? ''}',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      onPointerDown: (PointerDownEvent event) => setState(() => _event = event),
      onPointerMove: (PointerMoveEvent event) => setState(() => _event = event),
      onPointerUp: (PointerUpEvent event) => setState(() => _event = event),
    );
  }
}

class GestureTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GestureTestState();
  }
}

class _GestureTestState extends State<GestureTest> {
  //手势识别-点击、双击、长按
  String _operation = "无手势识别事件!"; //保存事件名
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          color: Colors.blue,
          width: 200.0,
          height: 100.0,
          child: Text(
            _operation,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
        onTap: () => updateText("点击"), //点击
        onDoubleTap: () => updateText("双击"), //双击
        onLongPress: () => updateText("长按"), //长按
      ),
    );
  }

  void updateText(String text) {
    //更新显示的事件名
    setState(() {
      _operation = text;
    });
  }
}

class Drag extends StatefulWidget {
  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<Drag> with SingleTickerProviderStateMixin {
  //手势识别-拖动、滑动
  double _top = 0.0; //距顶部的偏移
  double _left = 0.0; //距左边的偏移

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: _top,
          left: _left,
          child: GestureDetector(
            child: CircleAvatar(child: Text("A")),
            //手指按下时会触发此回调
            onPanDown: (DragDownDetails e) {
              //打印手指按下的位置(相对于屏幕)
              print("用户手指按下：${e.globalPosition}");
            },
            //手指滑动时会触发此回调
            onPanUpdate: (DragUpdateDetails e) {
              //用户手指滑动时，更新偏移，重新构建
              setState(() {
                _left += e.delta.dx;
                _top += e.delta.dy;
              });
            },
            onPanEnd: (DragEndDetails e) {
              //打印滑动结束时在x、y轴上的速度
              print(e.velocity);
            },
          ),
        )
      ],
    );
  }
}

class DragVertical extends StatefulWidget {
  @override
  _DragVerticalState createState() => _DragVerticalState();
}

class _DragVerticalState extends State<DragVertical> {
  //手势识别-竖向方向拖动
  double _top = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: _top,
          child: GestureDetector(
            child: CircleAvatar(child: Text("A")),
            //垂直方向拖动事件
            onVerticalDragUpdate: (DragUpdateDetails details) {
              setState(() {
                _top += details.delta.dy;
              });
            },
          ),
        )
      ],
    );
  }
}

class _GestureRecognizer extends StatefulWidget {
  //手势识别-点击事件处理
  const _GestureRecognizer({Key? key}) : super(key: key);

  @override
  _GestureRecognizerState createState() => _GestureRecognizerState();
}

class _GestureRecognizerState extends State<_GestureRecognizer> {
  TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  bool _toggle = false; //变色开关

  @override
  void dispose() {
    //用到GestureRecognizer的话一定要调用其dispose方法释放资源
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "你好世界",
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
            TextSpan(
              text: "点我变色",
              style: TextStyle(
                fontSize: 35.0,
                color: _toggle ? Colors.blue : Colors.red,
              ),
              recognizer: _tapGestureRecognizer
                ..onTap = () {
                  setState(() {
                    _toggle = !_toggle;
                  });
                },
            ),
            TextSpan(
              text: "你好世界",
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
