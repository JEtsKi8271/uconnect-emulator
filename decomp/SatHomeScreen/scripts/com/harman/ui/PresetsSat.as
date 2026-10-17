package com.harman.ui
{
   import core.utils.Text;
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public class PresetsSat extends BaseMovieClip implements IMovieClip
   {
      
      public const LENGTH:int = 6;
      
      private var mNoSignal:Boolean = false;
      
      private var mPosition:int = 0;
      
      private var mSelected:int = -1;
      
      public var item0_button:ButtonPreset;
      
      public var item1_button:ButtonPreset;
      
      public var item2_button:ButtonPreset;
      
      public var item3_button:ButtonPreset;
      
      public var item4_button:ButtonPreset;
      
      public var item5_button:ButtonPreset;
      
      public var nextPrevious_button:ButtonBarIconOnly;
      
      public function PresetsSat()
      {
         super();
      }
      
      public function get position() : int
      {
         return this.mPosition;
      }
      
      public function set position(_position:int) : void
      {
         var buttonVarName:String = null;
         this.mPosition = _position;
         for(var i:int = 0; i < this.LENGTH; i++)
         {
            buttonVarName = this.constructButtonVarName(i);
            this[buttonVarName].id = this.mPosition + i;
            this[buttonVarName].labelNbr.text = String(this.mPosition + i + 1);
         }
         this.nextPrevious_button.icon.gotoAndStop(this.mPosition == 0 ? 1 : 2);
      }
      
      public function set selected(_selected:int) : void
      {
         this.mSelected = _selected;
      }
      
      public function set noSignal(_noSignal:Boolean) : void
      {
         this.mNoSignal = _noSignal;
      }
      
      public function set data(_data:Array) : void
      {
         var i:int = 0;
         var buttonVarName:String = null;
         var isSelected:Boolean = false;
         if(_data != null && _data.length > 0)
         {
            for(i = 0; i < this.LENGTH; i++)
            {
               buttonVarName = this.constructButtonVarName(i);
               if(_data[i].StationName != null && Boolean(_data[i].Active))
               {
                  isSelected = this[buttonVarName].id == this.mSelected;
                  this[buttonVarName].beep = true;
                  this[buttonVarName].labelName.visible = true;
                  this[buttonVarName].labelHoldToSet.visible = false;
                  Text.truncateCharacters(this[buttonVarName].labelName,_data[i].StationName,false,"");
                  this[buttonVarName].setHighlight(isSelected && _data[i].Active);
                  if(this.mNoSignal)
                  {
                     Skin.style.applyStyle(this[buttonVarName].labelNbr,Skin.style.currentTheme.disabledText);
                     Skin.style.applyStyle(this[buttonVarName].labelName,Skin.style.currentTheme.disabledText);
                  }
                  else
                  {
                     Skin.style.applyStyle(this[buttonVarName].labelNbr,Skin.style.currentTheme.primaryText);
                     Skin.style.applyStyle(this[buttonVarName].labelName,Skin.style.currentTheme.primaryText);
                  }
               }
               else
               {
                  this[buttonVarName].beep = false;
                  this[buttonVarName].labelName.visible = false;
                  this[buttonVarName].labelHoldToSet.visible = true;
                  this[buttonVarName].setHighlight(false);
                  Skin.style.applyStyle(this[buttonVarName].labelNbr,Skin.style.currentTheme.disabledText);
               }
            }
         }
      }
      
      private function constructButtonVarName(i:int) : String
      {
         return "item" + i + "_button";
      }
   }
}

