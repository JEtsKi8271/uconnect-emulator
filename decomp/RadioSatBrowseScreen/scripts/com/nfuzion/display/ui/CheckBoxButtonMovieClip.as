package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class CheckBoxButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public function CheckBoxButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonTextColors() : void
      {
      }
      
      override protected function setButtonImageColors() : void
      {
         Skin.style.applyStyle(this.btnDown,Skin.style.currentTheme.downStateStandard);
      }
      
      override protected function showOrHideButtonImages() : void
      {
         setVisible(this.btnDown,mCurrentState == STATE_DOWN);
      }
      
      override protected function setButtonIconColor() : void
      {
         if(this.icon != null)
         {
            switch(mCurrentState)
            {
               case STATE_UP:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.disabledIcon);
                  this.icon.visible = false;
                  break;
               case STATE_DOWN:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.downIcon);
                  break;
               case STATE_ACTIVE:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.activeIcon);
                  this.icon.visible = true;
                  break;
               case STATE_DISABLED:
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.disabledIcon);
            }
         }
      }
   }
}

