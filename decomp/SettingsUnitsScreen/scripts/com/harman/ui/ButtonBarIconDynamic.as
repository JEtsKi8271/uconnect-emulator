package com.harman.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public class ButtonBarIconDynamic extends ButtonMovieClip
   {
      
      public var icon:MovieClip;
      
      public var label:TextField;
      
      public var colorize:MovieClip;
      
      public function ButtonBarIconDynamic()
      {
         super();
      }
      
      override protected function setFont() : void
      {
         this.label;
         Skin.style.applyFont(this.label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.icon.gotoAndStop(1);
               this.colorize.visible = false;
               this.label;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardUpIcon);
               break;
            case STATE_DOWN:
               this.icon.gotoAndStop(2);
               this.colorize.visible = true;
               this.label;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.tertiaryText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDownIcon);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.icon.gotoAndStop(3);
               this.colorize.visible = true;
               this.label;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardActiveIcon);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               this.icon.gotoAndStop(4);
               this.colorize.visible = false;
               this.label;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDisabledIcon);
         }
         mCurrentState = state;
      }
   }
}

