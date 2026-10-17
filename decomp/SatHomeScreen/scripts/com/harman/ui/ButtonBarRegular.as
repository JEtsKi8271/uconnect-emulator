package com.harman.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public class ButtonBarRegular extends ButtonMovieClip
   {
      
      public var label:TextField;
      
      public var colorize:MovieClip;
      
      public var cursor:MovieClip;
      
      public function ButtonBarRegular()
      {
         super();
      }
      
      override protected function setFont() : void
      {
         Skin.style.applyFont(this.label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.colorize.visible = false;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               break;
            case STATE_DOWN:
               this.colorize.visible = true;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.tertiaryText);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.colorize.visible = true;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               this.colorize.visible = false;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.disabledText);
         }
         mCurrentState = state;
      }
   }
}

