package com.harman.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class PopupNavLoading extends BaseMovieClip implements IMovieClip
   {
      
      public var label:TextField;
      
      public function PopupNavLoading()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.label,Skin.style.currentTheme.FONT_PRIMARY);
      }
   }
}

