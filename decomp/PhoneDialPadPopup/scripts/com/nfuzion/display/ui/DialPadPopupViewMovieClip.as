package com.nfuzion.display.ui
{
   import com.harman.ui.ScreenMovieClip;
   import core.locale.LocaleArchive;
   import core.utils.Graphic;
   import core.utils.Text;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   import skin.Skin;
   
   public dynamic class DialPadPopupViewMovieClip extends ScreenMovieClip
   {
      
      public var labelTitle_translate:TextField;
      
      public var btns_group:MovieClip;
      
      public var dialPadDisplay:MovieClip;
      
      public function DialPadPopupViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.labelTitle_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.dialPadDisplay.labelValue,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.labelTitle_translate,Skin.style.currentTheme.titleText);
         Skin.style.applyStyle(this.dialPadDisplay.labelValue,Skin.style.currentTheme.LCDText);
      }
      
      override protected function updateAlignment() : void
      {
         Graphic.mirror(this.btns_group.btnBackspaceButton);
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.labelTitle_translate.x = 455;
            this.btns_group.btnClose_button.x = -171;
            this.btns_group.btnBackspaceButton.x = -10;
            Text.align(this.labelTitle_translate,TextFormatAlign.RIGHT);
         }
         else
         {
            this.labelTitle_translate.x = 20;
            this.btns_group.btnClose_button.x = 372;
            this.btns_group.btnBackspaceButton.x = 275;
            Text.align(this.labelTitle_translate,TextFormatAlign.LEFT);
         }
      }
   }
}

