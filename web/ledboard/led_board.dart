library ledboard;

import 'dart:html';
import 'character/character_list.dart';
import 'character/character_matrix.dart';
import 'led/led.dart';

class LedBoard {
  
  num width, height, characterWidth, characterHeight, ledRadius, ledSpacing, rowSize, columnSize, currentStartRow;
  int wordLength;
  String inactiveColor, activeColor, displayString;
  List<CharacterMatrix> charactersToUse;
  List<List<Led>> leds;
  CharacterList characterList;
  CanvasElement canvas;
  int advanceCount = 0;
  bool advanceIsFirst = true;
  
  LedBoard(CanvasElement displayCanvas, num boardWidth, num boardHeight, num letterWidth, num letterHeight, num singleLEDRadius, num singleLEDSpacing, String ledInactiveColor, String ledActiveColor){
    
    this.canvas = displayCanvas;
    this.width = boardWidth;
    this.height = boardHeight;
    this.characterWidth = letterWidth;
    this.characterHeight = letterHeight;
    this.ledRadius = singleLEDRadius;
    this.ledSpacing = singleLEDSpacing;
    this.activeColor = ledActiveColor;
    this.inactiveColor = ledInactiveColor;
    
    characterList = new CharacterList();
    
    setupGrid();
    
  }
  
  void setDisplayString(String value){
    
    this.displayString = value;
    this.wordLength = this.displayString.length;
    this.currentStartRow = this.columnSize;
    this.charactersToUse = new List<CharacterMatrix>(this.wordLength);
    
    num i = 0;
    for(i; i < this.wordLength; i++){
      List<int> letterCode = new List<int>();
      letterCode.add(displayString.charCodes[i]);
      charactersToUse[i] = this.setCharacter(new String.fromCharCodes(letterCode));
    }
    
  }
  
  void setupGrid(){
    
    num singleLEDWidth = (this.ledRadius * 2) + (this.ledSpacing - (this.ledRadius * 2));
    this.columnSize = this.width / singleLEDWidth;
    this.columnSize = this.columnSize.round();
    this.rowSize = this.characterHeight;
    num ledCount = this.columnSize * this.rowSize;
    
    this.leds = new List<List<Led>>(this.columnSize.toInt());
    num buildCount = 0;
    for(buildCount; buildCount < this.columnSize; buildCount++){
      this.leds[buildCount] = new List<Led>(this.rowSize);
    }
    
    num i = 0;
    for(i; i < ledCount; i++){
      Led newLed = new Led(this.ledRadius, this.inactiveColor, this.activeColor, this.canvas);
      num ledYMath = i / columnSize;
      ledYMath = ledYMath.floor();
      num ledXMath = i - ledYMath * this.columnSize;
      newLed.boardPosition.y = (ledYMath * this.ledSpacing) + (this.ledRadius);
      newLed.boardPosition.x = (ledXMath * this.ledSpacing) + (this.ledRadius);
      this.leds[ledXMath.toInt()][ledYMath.toInt()] = newLed;
      newLed.setInactive();
    }
    
  }
  
  CharacterMatrix createCharacterMatrix(List<num> charData){
    
    CharacterMatrix charMat = new CharacterMatrix(this.characterWidth, this.characterHeight);
    num i = 0;
    num count = 0; //count can possibly be removed, double check once all is working
    for(i; i < charData.length; i++){
      num row = i / this.characterWidth;
      row = row.floor();
      num col = i - row * this.characterWidth;
      charMat.data[col.toInt()][row.toInt()] = charData[count.toInt()];
      count += 1;
    }
    return charMat;
  }
  
  CharacterMatrix setCharacter(String char){
    List<num> charList = this.characterList.getCharacter(char);
    CharacterMatrix charMat = this.createCharacterMatrix(charList);
    return charMat;
  }
  
  void advance(num _){
    
    this.makeAllInactive();
    this.advanceCount = 0;
    this.advanceIsFirst = true;
    
    this.charactersToUse.forEach(activateMatrix);
    
    this.currentStartRow -= 1;
    if(this.currentStartRow > columnSize) this.currentStartRow = this.columnSize;
    if(this.currentStartRow < -((this.wordLength * this.characterWidth) + this.wordLength) ) this.currentStartRow = this.columnSize;
    
    this.requestRedraw();
    
  }
  
  void activateMatrix(CharacterMatrix matrix){
    
    int toAdd = (this.advanceIsFirst) ? 0 : 1;
    toAdd *= advanceCount;
    this.applyMatrixAtPosition(matrix, ((this.advanceCount * this.characterWidth) + this.currentStartRow + toAdd));
    advanceCount += 1;
    if(this.advanceIsFirst) this.advanceIsFirst = false;
    
  }
  
  void applyMatrixAtPosition(CharacterMatrix matrix, num startCol){
    int i = 0;
    for(i; i < matrix.getLength(); i++){
      int k = 0;
      for(k; k < this.characterHeight; k++){
        if(i+startCol >=0 && i+startCol < this.columnSize){
          if(matrix.data[i][k] == 1){
            int value = i + startCol.toInt();
            leds[value][k].setActive();
          }
        }
      }
    }
  }
  
  void makeAllInactive(){
    this.leds.forEach(this.makeColumnInactive); 
  }
  
  void makeColumnInactive(List<Led> element){
    element.forEach(this.makeLEDInactive);
  }
  
  void makeLEDInactive(Led element){
    element.setInactive();
  }
  
  void start(){
    this.requestRedraw();
  }
  
  void requestRedraw(){
    window.requestAnimationFrame(this.advance);
  }
  
}
