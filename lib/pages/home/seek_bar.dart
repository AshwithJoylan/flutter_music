import 'package:flutter/material.dart';
import 'package:fluttery/gestures.dart';
import 'dart:math';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music/pages/utils/colors.dart';


class AudioRadialSeekbar extends StatefulWidget {
  @override
  _AudioRadialSeekbarState createState() => _AudioRadialSeekbarState();
}

class _AudioRadialSeekbarState extends State<AudioRadialSeekbar> {
  
  double _seekPercent;

  @override
  Widget build(BuildContext context) {
    return AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayhead,
        WatchableAudioProperties.audioSeeking
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        double playBackProgress = 0.0;
        if (player.audioLength != null && player.position != null) {
          playBackProgress = player.position.inMilliseconds / player.audioLength.inMilliseconds;
        }

        _seekPercent = player.isSeeking ? _seekPercent: null;

        return RadialSeekBar(
          progress: playBackProgress,
          seekPercent: _seekPercent,
          onSeekRequested: (double seekPercent) {
            setState(() {
              _seekPercent = seekPercent;

              final secMills  = (player.audioLength.inMilliseconds * seekPercent).round();
              player.seek(Duration(milliseconds: secMills));                 
            });
          },
      );
      },
    );
  }
}

class RadialSeekBar extends StatefulWidget {
  
  final double seekPercent;
  final double progress;
  final Function(double) onSeekRequested; 

  RadialSeekBar({
    this.seekPercent = 0.0,
    this.progress = 0.0,
    this.onSeekRequested
  });

  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {

  PolarCoord _startCoord;
  double _startDragPercent;
  double _progress = 0.0;
  double _currentDragPercent;

  @override
    void didUpdateWidget(RadialSeekBar oldWidget) {
      super.didUpdateWidget(oldWidget);

      _progress = widget.progress;
    }

  void initState() { 
    super.initState();
    _progress = widget.progress;
  }

  void _dragStart(PolarCoord coord) {
    _startCoord = coord;
    _startDragPercent = _progress;
  }

  void _dragEnd() {

    if (widget.onSeekRequested != null) {
      widget.onSeekRequested(_currentDragPercent);
    }

    setState(() {
          _currentDragPercent = null;
          _startDragPercent = 0;
          _startCoord = null;
        });
  }

  void _dragUpdate(PolarCoord coord) {
    final dragAngle = coord.angle - _startCoord.angle;
    final dragPercent = dragAngle / (pi);

    setState(() {
          _currentDragPercent = ( _startDragPercent + dragPercent ) % 1.0;
        });
  }
  
  @override
  Widget build(BuildContext context) {

    double thumbPosition = _progress;
    if (_currentDragPercent != null) {
      thumbPosition = _currentDragPercent;
    } else if (widget.seekPercent != null) {
      thumbPosition = widget.seekPercent;
    }

    return RadialDragGestureDetector(
      onRadialDragStart:  _dragStart,
      onRadialDragEnd: _dragEnd,
      onRadialDragUpdate: _dragUpdate,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            width: 280,
            height: 280,
            color: Colors.transparent,
            child: MyProgressBar(
              progressPercent: _progress,
              thumbPosition: thumbPosition,
              innerPadding: EdgeInsets.all(15),
              outerPadding: EdgeInsets.all(10),
              thumbColor: Colors.orange,
              progressColor: Colors.orange,
              trackColor: Color(0xfffeded8),
          ),
          ),
        ),
      ),
    );
  }
}

class MyProgressBar extends StatefulWidget {

  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double thumbSize;
  final Color thumbColor;
  final Widget child;
  final double progressPercent;
  final double thumbPosition;
  final EdgeInsets innerPadding;
  final EdgeInsets outerPadding;

  MyProgressBar({
    this.trackWidth = 3.0,
    this.trackColor = Colors.grey, 
    this.progressWidth = 5.0, 
    this.progressColor = Colors.orange, 
    this.thumbSize = 10.0, 
    this.thumbColor = Colors.orange,
    this.progressPercent = 0.0,
    this.thumbPosition = 0.0,
    this.child, 
    this.innerPadding = const EdgeInsets.all(0.0), 
    this.outerPadding = const EdgeInsets.all(0.0)
  });

  @override
  _MyProgressBarState createState() => _MyProgressBarState();
}

class _MyProgressBarState extends State<MyProgressBar> {

  EdgeInsets _insetForPainter() {

    final outerThickness = max(widget.trackWidth, max(widget.progressWidth, widget.thumbSize)) / 2;
    return EdgeInsets.all(outerThickness);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.outerPadding,
      child: CustomPaint(
        foregroundPainter: RadialSeekBarPainter(
          progressColor: widget.progressColor,
          progressWidth: widget.progressWidth,
          progressPercent: widget.progressPercent,
          trackColor: widget.trackColor,
          trackWidth: widget.trackWidth,
          thumbColor: widget.thumbColor,
          thumbPosition: widget.thumbPosition,
          thumbSize: widget.thumbSize,
        ),
              child: Padding(
                padding: _insetForPainter() + widget.innerPadding,
                child: widget.child,
              ),
            ),
    );
        }
}

class RadialSeekBarPainter extends CustomPainter{

  final double trackWidth;
  final Paint trackPaint;
  final double progressWidth;
  final double thumbSize;
  final double progressPercent;
  final double thumbPosition;

  RadialSeekBarPainter({
    @required this.trackWidth,
    @required trackColor, 
    @required this.progressWidth, 
    @required progressColor, 
    @required this.thumbSize, 
    @required thumbColor,
    @required this.progressPercent,
    @required this.thumbPosition,
  }) : trackPaint = Paint()
    ..color = trackColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = trackWidth;
    

  @override
  void paint(Canvas canvas, Size size) {
    
    final outeContainer = max(trackWidth, max(progressWidth, thumbSize));

    Size containerSize = new Size(
      size.width - outeContainer,
      size.height - outeContainer 
    );

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(containerSize.width, containerSize.height) / 2;
  
    //Paint Track 
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius
      ), 
      -pi , 
      pi, 
      false, trackPaint);

    Paint progressPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = progressWidth
    ..strokeCap = StrokeCap.round
    ..shader = SweepGradient(
      startAngle: -pi,
      endAngle: 0,
      colors: [
        redishOrange,
        Colors.orange,
        Colors.yellow
      ],
      tileMode: TileMode.mirror
    ).createShader(Rect.fromCircle(
      center: center,
      radius: radius
    ));

    //Paint Progress
    final progressAngle = pi * progressPercent;
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius
      ), 
      pi, 
      progressAngle,
      false,
      progressPaint 
      );

      Paint thumbPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = thumbSize
    ..strokeCap = StrokeCap.round
    ..shader = SweepGradient(
      startAngle: -pi,
      endAngle: 0,
      colors: [
        redishOrange,
        Colors.orange,
        Colors.yellow
      ],
      tileMode: TileMode.mirror
    ).createShader(Rect.fromCircle(
      center: center,
      radius: radius
    ));
    
    //thumb Painting
    final thumbAngle = pi * thumbPosition - (pi);
    final thumbx = cos(thumbAngle) * radius;
    final thumby = sin(thumbAngle) * radius;
    final thumbCenter = Offset(thumbx, thumby) + center; 
    final thumbRadius = thumbSize / 2;
    canvas.drawCircle(
      thumbCenter, 
      thumbRadius, 
      thumbPaint
      );


    final innerThumbRadius = thumbSize / 2.3;
    canvas.drawCircle(
      thumbCenter, 
      innerThumbRadius, 
      Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
    );

    // Path path = Path();
    // path.moveTo(0, size.height /2);
    // path.addRRect(RRect.fromRectAndCorners(
    //   Rect.fromLTRB(0.0, containerSize.height / 2, 30, 40),
    //   topLeft: Radius.circular(40),
    //   bottomLeft: Radius.circular(40),
    //   ));
    
    // path.arcToPoint(
    //   Offset(size.width, size.height / 2),
    //   radius: Radius.circular(radius),
    //   clockwise: true,
    //   rotation: 30,
    //   largeArc: false
    // );  

    // canvas.drawPath(path, Paint()
    // ..color = Colors.orange
    // ..strokeWidth = 4
    // ..style = PaintingStyle.stroke);
}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}