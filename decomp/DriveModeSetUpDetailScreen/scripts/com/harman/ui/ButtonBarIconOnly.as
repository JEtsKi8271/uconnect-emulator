package com.harman.ui
{
   import flash.display.MovieClip;
   import skin.Skin;
   
   public class ButtonBarIconOnly extends ButtonMovieClip
   {
      
      public var icon:MovieClip;
      
      public var colorize:MovieClip;
      
      public var cursor:MovieClip;
      
      public function ButtonBarIconOnly()
      {
         super();
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.colorize.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardUpIcon);
               break;
            case STATE_DOWN:
               this.colorize.visible = true;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDownIcon);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.colorize.visible = true;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardActiveIcon);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               this.colorize.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDisabledIcon);
         }
         mCurrentState = state;
      }
   }
}

