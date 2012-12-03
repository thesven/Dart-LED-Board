library ledboard;

import '../struct/led_point.dart';
import 'dart:html';
import 'dart:math';

class Led {
  
  num radius;
  String activeColor;
  String inactiveColor;
  LedPoint boardPosition;
  CanvasElement canvas;
  
  Led(num ledRadius, String ledActiveColor, String ledInactiveColor, CanvasElement displayCanvas){
    
    this.radius = ledRadius;
    this.activeColor = ledActiveColor;
    this.inactiveColor = ledInactiveColor;
    this.boardPosition = new LedPoint(0, 0);
    this.canvas = displayCanvas;
    
  }
  
  void setInactive(){
    drawLED(this.inactiveColor, this.canvas.context2d);
  }
  
  void setActive(){
    drawLED(this.activeColor, this.canvas.context2d);
  }
  
  void drawLED(String color,CanvasRenderingContext2D context){
    context.beginPath();
    context.arc(this.boardPosition.x, this.boardPosition.y, this.radius, 0, PI * 2, false);
    context.fillStyle = color;
    context.fill();
    context.closePath();
  }
  
}
