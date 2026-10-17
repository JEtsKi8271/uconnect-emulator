package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class TLSportsColumnListButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var value1a_label:TextField;
      
      public var value2a_label:TextField;
      
      public var value1b_label:TextField;
      
      public var value2b_label:TextField;
      
      public var value3b_label:TextField;
      
      public var value1c_label:TextField;
      
      public var value2c_label:TextField;
      
      public var value3c_label:TextField;
      
      public var value4c_label:TextField;
      
      public function TLSportsColumnListButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonImageColors() : void
      {
         Skin.style.applyStyle(this.btnUp,Skin.style.currentTheme.upStateList);
         Skin.style.applyStyle(this.btnDown,Skin.style.currentTheme.downStateList);
         Skin.style.applyStyle(this.btnActive,Skin.style.currentTheme.activeStateList);
         Skin.style.applyStyle(this.btnDisabled,Skin.style.currentTheme.disabledStateList);
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyStyle(this.btnUp,Skin.style.currentTheme.upStateList);
         Skin.style.applyStyle(this.btnDown,Skin.style.currentTheme.downStateList);
         Skin.style.applyStyle(this.btnActive,Skin.style.currentTheme.activeStateList);
         Skin.style.applyStyle(this.btnDisabled,Skin.style.currentTheme.disabledStateList);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.btnUp,Skin.style.currentTheme.upStateList);
         Skin.style.applyStyle(this.btnDown,Skin.style.currentTheme.downStateList);
         Skin.style.applyStyle(this.btnActive,Skin.style.currentTheme.activeStateList);
         Skin.style.applyStyle(this.btnDisabled,Skin.style.currentTheme.disabledStateList);
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.value1_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.value2_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.value3_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.value4_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.value1_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.value2_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.value3_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.value4_label,Skin.style.currentTheme.primaryText);
      }
   }
}

