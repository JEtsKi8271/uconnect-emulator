package com.harman.ui
{
   import flash.display.MovieClip;
   import skin.Skin;
   
   public class ButtonArrow extends ButtonMovieClip
   {
      
      public var colorize:MovieClip;
      
      public function ButtonArrow()
      {
         super();
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.visible = true;
               this.colorize.visible = false;
               break;
            case STATE_DOWN:
               this.visible = true;
               this.colorize.visible = true;
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.visible = true;
               this.colorize.visible = true;
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               this.visible = false;
         }
         mCurrentState = state;
      }
      
      override public function setEnabled(enabled:Boolean) : void
      {
         mActive = false;
         mEnabled = enabled;
         if(enabled)
         {
            if(mCurrentState != STATE_DOWN)
            {
               this.setState(STATE_UP);
            }
         }
         else
         {
            this.setState(STATE_DISABLED);
         }
      }
   }
}

