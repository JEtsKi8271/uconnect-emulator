package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class BrowseHeadlineRowMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var browseHeadlineRow:TextField;
      
      public function BrowseHeadlineRowMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.browseHeadlineRow,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.browseHeadlineRow,Skin.style.currentTheme.primaryText);
      }
   }
}

