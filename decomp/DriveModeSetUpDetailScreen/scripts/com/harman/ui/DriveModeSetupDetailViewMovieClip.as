package com.harman.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class DriveModeSetupDetailViewMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var content:TextField;
      
      public var display_type_infor:TextField;
      
      public var label:TextField;
      
      public function DriveModeSetupDetailViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.content,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.type_infor.display_type_infor,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.warning.label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.content,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.type_infor.display_type_infor,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.warning.label,Skin.style.currentTheme.primaryText);
      }
   }
}

