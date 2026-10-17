package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class CallButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public function CallButtonMovieClip()
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
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.phoneactiveUpIcon);
                  break;
               case STATE_DOWN:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.phoneactiveDownIcon);
                  break;
               case STATE_ACTIVE:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.phoneactiveActiveIcon);
                  break;
               case STATE_DISABLED:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.phoneactiveDisabledIcon);
            }
         }
      }
   }
}

