library ledboard;

class CharacterMatrix {
  
  num cols, rows;
  List<List<num>> data;
  
  CharacterMatrix(num totalColumns, num totalRows){
    
    this.cols = totalColumns;
    this.rows = totalRows;
   
    data = new List<List<num>>(this.cols);
    
    num i = 0;
    for(i; i < this.cols; i++){
      data[i] = new List<num>(this.rows);
      num j = 0;
      for(j; j < this.rows; j++){
        data[i][j] = 0;
      }
    }
    
  }
  
  int getLength(){
    return data.length;
  }
  
}
