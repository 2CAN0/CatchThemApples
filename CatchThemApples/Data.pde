class PlayerInfo {
   Table info;
   int coins;
   int selected;
   String tableLoc;
   ArrayList<String> boughtChars = new ArrayList<String>();
   
   PlayerInfo(Table t, String tl){
     info = t;
     tableLoc = tl;
     coins = info.getInt(0,1);
     selected = info.getInt(0,2);
     
     playerName = info.getString(0, 4);
     
     for(TableRow tr : info.rows()){  
       boughtChars.add(tr.getString(3));
     }
   }
   
   void read(){
     String bought = "";
     for(String charachter : boughtChars){
       bought += charachter + ", ";
     }
      println("ID: "+info.getInt(0,0)+"    Coins: "+info.getInt(0,1)+"    Selected: "+info.getInt(0,2)+"    Bought: "+bought);
   }
   
   void update(){
       info.setInt(0, 1, coins);
       info.setInt(0, 2, selected);
       try{
         info.setInt(0, 3, Integer.parseInt(boughtChars.get(0)));
         for (int iRow = 1; iRow < boughtChars.size(); iRow++){
            info.setInt(iRow,3,Integer.parseInt(boughtChars.get(iRow))); 
         }
       } catch (Exception ex){
          println("An error has encountered while parse your string to integers"); 
          println("Error: "+ ex.getMessage());
       }
   }
   
   void save(){
       update();
       try{
         saveTable(info, tableLoc);
         println("Table saved Succesfully");
       } catch (Exception ex){
          println("Something went wrong while saving the player info");
          println("Error: "+ex.getMessage());
       }
   }
}
