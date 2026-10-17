package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ButtonListenNow extends ButtonMovieClip implements IMovieClip
   {
      
      public var team_label:TextField;
      
      public function ButtonListenNow()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         if(this.team_label != null)
         {
            Skin.style.applyFont(this.team_label,Skin.style.currentTheme.FONT_PRIMARY);
         }
      }
      
      override protected function setButtonTextColors() : void
      {
         if(this.team_label != null)
         {
            switch(mCurrentState)
            {
               case STATE_UP:
                  Skin.style.applyStyle(this.team_label,Skin.style.currentTheme.primaryText);
                  break;
               case STATE_DOWN:
                  Skin.style.applyStyle(this.team_label,Skin.style.currentTheme.tertiaryText);
                  break;
               case STATE_ACTIVE:
                  Skin.style.applyStyle(this.team_label,Skin.style.currentTheme.primaryText);
                  break;
               case STATE_DISABLED:
                  Skin.style.applyStyle(this.team_label,Skin.style.currentTheme.disabledText);
            }
         }
      }
   }
}

