import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:flutter_learning/model/time_line_node_obj.dart';

class TimeLine extends StatefulWidget {
  const TimeLine({super.key});

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  final completeColor = Color(0xFFFFD754);
  final inProgressColor = Color(0xFFFFD754);
  final todoColor = Color(0xffd1d2d7);
  final rejectedColor = Color(0xFFF65959);

  final completeColorFont = Color(0xFFEBBF2E);
  final inProgressColorFont = Color(0xFFEBBF2E);
  final todoColorFont = Color(0xFFE0E0E0);
  final rejectedColorFont = Color(0xFFF65959);

  GlobalKey _container = GlobalKey();
  GlobalKey height_1 = GlobalKey();
  GlobalKey height_2 = GlobalKey();
  double containerHeight = 300;
  double containerWidth = 300;

  List<TimeLineNodeObj> list = [
    TimeLineNodeObj(
      nodeCotent: "第一個節點",
      name: "小明",
      date: "2023-10-01",
      time: "12:00",
      nodeType: TimeLineNodeType.checked,
    ),
    TimeLineNodeObj(
      nodeCotent: "第二個節點",
      name: "中明",
      date: "2023-10-01",
      time: "12:00",
      nodeType: TimeLineNodeType.current,
    ),
    TimeLineNodeObj(
      nodeCotent: "第三個節點",
      name: "大明",
      date: "2023-10-01",
      time: "12:00",
      nodeType: TimeLineNodeType.rejected,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateContainerHeight();
    });
  }

  void _updateContainerHeight() {
    final RenderBox renderContainer = _container.currentContext?.findRenderObject() as RenderBox;
    final RenderBox renderBox1 = height_1.currentContext?.findRenderObject() as RenderBox;
    final RenderBox renderBox2 = height_2.currentContext?.findRenderObject() as RenderBox;
    final size1 = renderBox1.size;
    final size2 = renderBox2.size;
    setState(() {
      containerHeight = size1.height + size2.height + 50;
      containerWidth = renderContainer.size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _container,
      height: containerHeight,
      alignment: Alignment.topCenter,
      //color: Colors.blue,
      child: Timeline.tileBuilder(
        //Theme
        theme: TimelineThemeData(
          nodePosition: 0.3,
          direction: Axis.horizontal,
          connectorTheme: ConnectorThemeData(
            space: 30.0, // Distance between dots
            thickness: 3.2,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          contentsAlign: ContentsAlign.basic,
          connectionDirection: ConnectionDirection.before,
          //itemExtentBuilder: (_, __) => MediaQuery.of(context).size.width / (list.length >= 4 ? 4 : list.length),
          itemExtentBuilder: (_, __) => containerWidth / 3,
          connectorBuilder: (context, index, position) {
            return DecoratedLineConnector(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.red],
                ),
              ),
            );
          },
          oppositeContentsBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(list[index].nodeCotent),
            );
          },
          contentsBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Column(
                key: index == 0 ? height_2 : null,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(list[index].name ?? ""),
                  Text(list[index].date ?? ""),
                  Text(list[index].time ?? ""),
                ],
              ),
            );
          },
          itemCount: list.length,
          indicatorBuilder: (context, index) {
            return Stack(
              key: index == 0 ? height_1 : null,
              children: [
                DotIndicator(
                  size: 30.0,
                  color: getColor(list[index].nodeType),
                  child: getIndicator(list[index].nodeType),
                ),
              ],
            );
          },
          // nodePositionBuilder: (context, index) {
          //   return 0;
          // }
        ),
      ),
    );
  }

  Widget getIndicator(TimeLineNodeType nodeType) {
    if (nodeType == TimeLineNodeType.pending) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.circle,
          color: Colors.white,
          size: 13.0,
        ),
      );
    } else if (nodeType == TimeLineNodeType.checked) {
      return Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 25.0,
      );
    } else if (nodeType == TimeLineNodeType.rejected) {
      return Center(
        child: Text(
          String.fromCharCode(Icons.close.codePoint),
          style: TextStyle(
            inherit: false,
            color: Colors.white,
            fontSize: 22.0,
            fontFamily: Icons.check.fontFamily,
            package: Icons.check.fontPackage,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    } else if (nodeType == TimeLineNodeType.current) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.circle,
          color: Colors.white,
          size: 13.0,
        ),
      );
    } else
      return Container();
  }

  Color getColor(TimeLineNodeType nodeType) {
    if (nodeType == TimeLineNodeType.pending) {
      return todoColor;
    } else if (nodeType == TimeLineNodeType.rejected) {
      return rejectedColor;
    } else if (nodeType == TimeLineNodeType.checked) {
      return completeColor;
    } else if (nodeType == TimeLineNodeType.current) {
      return inProgressColor;
    } else
      return inProgressColor;
  }
}
