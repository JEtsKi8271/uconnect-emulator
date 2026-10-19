package com.harman.ui
{
   import flash.display.MovieClip;
   import skin.Skin;
   
   public class ButtonClose extends ButtonMovieClip
   {
      
      public var icon:MovieClip;
      
      public var colorize:MovieClip;
      
      public function ButtonClose()
      {
         super();
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.closeUpIcon);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.upStateStandard);
               break;
            case STATE_DOWN:
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.closeDownIcon);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.closeActiveIcon);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.closeDisabledIcon);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.upStateStandard);
         }
         mCurrentState = state;
      }
   }
}

