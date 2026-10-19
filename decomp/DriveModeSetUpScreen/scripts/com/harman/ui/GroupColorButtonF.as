package com.harman.ui
{
   import core.utils.Text;
   import flash.display.IMovieClip;
   
   public class GroupColorButtonF extends BaseMovieClip implements IMovieClip
   {
      
      public var setUp_type_button:ButtonGroupTitle;
      
      public var setUp_top_button:ButtonActiveRed;
      
      public var setUp_center_button:ButtonActiveOrange;
      
      public var setUp_bottom_button:ButtonActiveYellow;
      
      public var setUp_4th_button:ButtonActiveDynamic;
      
      public var id:int = -1;
      
      private var mEnabled:Boolean = true;
      
      public function GroupColorButtonF()
      {
         super();
         if(this.setUp_type_button)
         {
            this.setUp_type_button.alwaysClick = true;
         }
      }
      
      public function set bottomColor(color:uint) : void
      {
         this.setUp_4th_button.setColor(color);
      }
      
      public function set enable(value:Boolean) : void
      {
         this.mEnabled = value;
         this.setUp_top_button.setEnabled(value);
         this.setUp_center_button.setEnabled(value);
         this.setUp_bottom_button.setEnabled(value);
         this.setUp_4th_button.setEnabled(value);
      }
      
      public function set labels(labels:Array) : void
      {
         Text.truncateCharacters(this.setUp_top_button.label,Text.getText(labels[0]));
         Text.truncateCharacters(this.setUp_center_button.label,Text.getText(labels[1]));
         Text.truncateCharacters(this.setUp_bottom_button.label,Text.getText(labels[2]));
         Text.truncateCharacters(this.setUp_4th_button.label,Text.getText(labels[3]));
      }
      
      public function set lockOut(value:Boolean) : void
      {
         if(this.setUp_type_button)
         {
            this.setUp_type_button.setEnabled(!value);
         }
      }
      
      public function set select(value:String) : void
      {
         this.setUp_top_button.setEnabled(Boolean(this.setUp_top_button.mEnabled) || value == this.setUp_top_button.label.text);
         this.setUp_top_button.setHighlight(value == this.setUp_top_button.label.text);
         this.setUp_center_button.setEnabled(Boolean(this.setUp_center_button.mEnabled) || value == this.setUp_center_button.label.text);
         this.setUp_center_button.setHighlight(value == this.setUp_center_button.label.text);
         this.setUp_bottom_button.setEnabled(Boolean(this.setUp_bottom_button.mEnabled) || value == this.setUp_bottom_button.label.text);
         this.setUp_bottom_button.setHighlight(value == this.setUp_bottom_button.label.text);
         this.setUp_4th_button.setEnabled(Boolean(this.setUp_4th_button.mEnabled) || value == this.setUp_4th_button.label.text);
         this.setUp_4th_button.setHighlight(value == this.setUp_4th_button.label.text);
      }
      
      public function set title(value:*) : void
      {
         if(this.setUp_type_button)
         {
            Text.truncateCharacters(this.setUp_type_button.label,Text.getText(value));
            this.setUp_type_button.label.y = 9;
            this.setUp_type_button.label.height = 50;
            if(this.setUp_type_button.label.numLines == 1)
            {
               this.setUp_type_button.label.y = 18;
               this.setUp_type_button.label.height = 30;
            }
         }
      }
   }
}

