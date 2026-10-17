package com.harman.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public class ButtonReplaySeek extends ButtonPressAndHold
   {
      
      public var label:TextField;
      
      public var icon:MovieClip;
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      public function ButtonReplaySeek()
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
               this.down.visible = false;
               this.active.visible = false;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardUpIcon);
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.upStateStandard);
               break;
            case STATE_DOWN:
               this.down.visible = true;
               this.active.visible = false;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.tertiaryText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDownIcon);
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.down.visible = false;
               this.active.visible = true;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardActiveIcon);
               Skin.style.applyStyle(this.active,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               this.down.visible = false;
               this.active.visible = false;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDisabledIcon);
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.upStateStandard);
         }
         mCurrentState = state;
      }
   }
}

