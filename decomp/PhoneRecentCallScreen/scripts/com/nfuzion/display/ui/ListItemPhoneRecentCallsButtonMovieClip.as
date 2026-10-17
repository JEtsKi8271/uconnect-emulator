package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import skin.Skin;
   
   public dynamic class ListItemPhoneRecentCallsButtonMovieClip extends ListButtonMovieClip implements IMovieClip
   {
      
      public var call_group:MovieClip;
      
      public var details_group:MovieClip;
      
      public function ListItemPhoneRecentCallsButtonMovieClip()
      {
         super();
         this.call_group.mouseEnabled = false;
         this.details_group.mouseEnabled = false;
         this.call_group.mouseChildren = false;
         this.details_group.mouseChildren = false;
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.call_group.name_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.call_group.name_label,Skin.style.currentTheme.primaryText);
      }
   }
}

