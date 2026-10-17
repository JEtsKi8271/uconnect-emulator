package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class CloseButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public function CloseButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonImageColors() : void
      {
         Skin.style.applyStyle(this.btnUp,Skin.style.currentTheme.upStateClose);
         Skin.style.applyStyle(this.btnDown,Skin.style.currentTheme.downStateClose);
         Skin.style.applyStyle(this.btnActive,Skin.style.currentTheme.activeStateClose);
         Skin.style.applyStyle(this.btnDisabled,Skin.style.currentTheme.disabledStateClose);
      }
      
      override protected function setButtonIconColor() : void
      {
         if(this.icon != null)
         {
            switch(mCurrentState)
            {
               case STATE_UP:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.closeUpIcon);
                  break;
               case STATE_DOWN:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.closeDownIcon);
                  break;
               case STATE_ACTIVE:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.closeActiveIcon);
                  break;
               case STATE_DISABLED:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.closeDisabledIcon);
            }
         }
      }
   }
}

