package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class ListItemSMSMessageListenButtonMovieClip extends ListButtonMovieClip implements IMovieClip
   {
      
      public function ListItemSMSMessageListenButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.value_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         if(this.value_label != null)
         {
            switch(mCurrentState)
            {
               case STATE_UP:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.primaryText);
                  break;
               case STATE_DOWN:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.tertiaryText);
                  break;
               case STATE_ACTIVE:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.primaryText);
                  break;
               case STATE_DISABLED:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.disabledText);
                  break;
               default:
                  Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.primaryText);
            }
         }
      }
   }
}

