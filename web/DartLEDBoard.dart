import 'dart:html';
import 'ledboard/led_board.dart';

void main() {
  
  LedBoard board = new LedBoard(query('#container'), 500, 72, 7, 6, 5, 12, '#000000', '#0000FF');
  board.setDisplayString("hello");
  board.start();
  
}

