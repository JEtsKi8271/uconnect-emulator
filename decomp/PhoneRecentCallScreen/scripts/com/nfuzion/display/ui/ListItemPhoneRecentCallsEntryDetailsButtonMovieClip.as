package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemPhoneRecentCallsEntryDetailsButtonMovieClip extends ListButtonMovieClip implements IMovieClip
   {
      
      public var name_label:TextField;
      
      public var select_label:TextField;
      
      public var dial_group:MovieClip;
      
      public function ListItemPhoneRecentCallsEntryDetailsButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.name_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.select_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.dial_group.dial_translate,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      public function setLabelFont(greyOut:Boolean) : void
      {
         if(greyOut)
         {
            Skin.style.applyStyle(this.dial_group.dial_translate,Skin.style.currentTheme.primaryText);
         }
         else
         {
            Skin.style.applyStyle(this.dial_group.dial_translate,Skin.style.currentTheme.disabledText);
         }
      }
      
      override protected function setButtonTextColors() : void
      {
         switch(mCurrentState)
         {
            case STATE_UP:
               Skin.style.applyStyle(this.name_label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.select_label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.dial_group.dial_translate,Skin.style.currentTheme.primaryText);
               break;
            case STATE_DOWN:
               Skin.style.applyStyle(this.name_label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.select_label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.dial_group.dial_translate,Skin.style.currentTheme.primaryText);
               break;
            case STATE_ACTIVE:
               Skin.style.applyStyle(this.name_label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.select_label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.dial_group.dial_translate,Skin.style.currentTheme.primaryText);
               break;
            case STATE_DISABLED:
               Skin.style.applyStyle(this.name_label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.select_label,Skin.style.currentTheme.primaryText);
               Skin.style.applyStyle(this.dial_group.dial_translate,Skin.style.currentTheme.disabledText);
         }
      }
   }
}

