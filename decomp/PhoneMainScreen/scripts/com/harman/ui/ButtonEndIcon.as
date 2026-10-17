package com.harman.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public class ButtonEndIcon extends ButtonMovieClip
   {
      
      public var icon:MovieClip;
      
      public var label:TextField;
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      public function ButtonEndIcon()
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
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.alertWarningIcon);
               Skin.style.applyStyle(this.active,Skin.style.currentTheme.alertWarningIcon);
               break;
            case STATE_DOWN:
               this.down.visible = true;
               this.active.visible = false;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.tertiaryText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.alertWarningIcon);
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.down.visible = false;
               this.active.visible = true;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.alertWarningIcon);
               Skin.style.applyStyle(this.active,Skin.style.currentTheme.alertWarningIcon);
               break;
            case STATE_DISABLED:
               this.down.visible = false;
               this.active.visible = false;
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.disabledText);
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.disabledIcon);
         }
         mCurrentState = state;
      }
   }
}

