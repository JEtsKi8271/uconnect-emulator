package com.harman.ui.button
{
   import core.widgets.WidgetButton;
   import flash.display.MovieClip;
   import skin.Skin;
   
   public class ButtonShiftLight extends WidgetButton
   {
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      public function ButtonShiftLight()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         super.setFont();
         if(this.down != null)
         {
            Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateStandard);
         }
         super.setState(getState());
      }
   }
}

