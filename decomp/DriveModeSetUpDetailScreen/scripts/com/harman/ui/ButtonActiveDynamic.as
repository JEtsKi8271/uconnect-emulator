package com.harman.ui
{
   public class ButtonActiveDynamic extends ButtonActiveColor
   {
      
      private const COLOR_BLUE:uint = 255;
      
      public function ButtonActiveDynamic()
      {
         super(this.COLOR_BLUE);
      }
      
      public function setColor(color:uint) : void
      {
         mActiveColor = color;
         setState(mCurrentState);
      }
   }
}

