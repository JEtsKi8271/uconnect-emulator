package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class AlertWarningButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public function AlertWarningButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonTextColors() : void
      {
         if(this.value_label != null)
         {
            switch(mCurrentState)
            {
               case STATE_UP:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.alertWarningText);
                  break;
               case STATE_DOWN:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.disabledText);
                  break;
               case STATE_ACTIVE:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.alertWarningText);
                  break;
               case STATE_DISABLED:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.disabledText);
            }
         }
      }
   }
}

