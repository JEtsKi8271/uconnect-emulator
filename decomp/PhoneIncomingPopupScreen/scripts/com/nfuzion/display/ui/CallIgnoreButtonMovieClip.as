package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class CallIgnoreButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public function CallIgnoreButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonIconColor() : void
      {
         if(this.icon != null)
         {
            switch(mCurrentState)
            {
               case STATE_UP:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.alertWarningIcon);
                  break;
               case STATE_DOWN:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.downIcon);
                  break;
               case STATE_ACTIVE:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.alertWarningIcon);
                  break;
               case STATE_DISABLED:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.disabledIcon);
            }
         }
      }
   }
}

