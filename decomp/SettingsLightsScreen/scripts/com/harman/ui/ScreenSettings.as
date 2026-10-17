package com.harman.ui
{
   import core.locale.LocaleArchive;
   import core.utils.Graphic;
   import core.utils.Text;
   import skin.Skin;
   
   public dynamic class ScreenSettings extends ScreenMovieClip
   {
      
      public var OneLineIncrementerFontSize:int = 24;
      
      public var OneLineIncrementerYCoord:int = 6;
      
      public var OneLineIncrementerHeight:int = 34;
      
      public var TwoLineIncrementerFontSize:int = 16;
      
      public var TwoLineIncrementerYCoord:int = 0;
      
      public var TwoLineIncrementerHeight:int = 45;
      
      public var OneLineLabelFontSize:int = 21;
      
      public var OneLineLabelYCoord:int = 8;
      
      public var OneLineLabelHeight:int = 34;
      
      public var TwoLineLabelFontSize:int = 21;
      
      public var TwoLineLabelYCoord:int = 8;
      
      public var TwoLineLabelHeight:int = 34;
      
      public var OneLineCheckFontSize:int = 18;
      
      public var OneLineCheckYCoord:int = 11;
      
      public var OneLineCheckHeight:int = 30;
      
      public var TwoLineCheckFontSize:int = 16;
      
      public var TwoLineCheckYCoord:int = 0;
      
      public var TwoLineCheckHeight:int = 45;
      
      public var LabelXCoord:int = 10;
      
      public var LabelXCoordIcon:int = 30;
      
      public var LabelArabicXFull:int = 30;
      
      public var LabelArabicXSelection:int = 41;
      
      public var LabelArabicXCheck1:int = 50;
      
      public var LabelArabicXCheck2:int = 234;
      
      public var LabelArabicXCheck3:int = 348;
      
      public var LabelArabicXIncrement:int = 142;
      
      public var LabelWidthFull:int = 500;
      
      public var LabelWidthFullArabic:int = 494;
      
      public var LabelWidthFullIcon:int = 470;
      
      public var LabelWidthSelection:int = 500;
      
      public var LabelWidthSelectionArabic:int = 483;
      
      public var LabelWidthSelectionIcon:int = 460;
      
      public var LabelWidthCheck1:int = 510;
      
      public var LabelWidthCheck1Arabic:int = 474;
      
      public var LabelWidthCheck1Icon:int = 450;
      
      public var LabelWidthCheck2:int = 510;
      
      public var LabelWidthCheck2Arabic:int = 291;
      
      public var LabelWidthCheck2Icon:int = 265;
      
      public var LabelWidthCheck3:int = 510;
      
      public var LabelWidthCheck3Arabic:int = 176;
      
      public var LabelWidthCheck3Icon:int = 155;
      
      public var LabelWidthIncrement:int = 510;
      
      public var LabelWidthIncrementArabic:int = 382;
      
      public var LabelWidthIncrementIcon:int = 360;
      
      public function ScreenSettings()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.total,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function updateAlignment() : void
      {
         this.window.updateAlignment();
         Text.align(this.title.label);
         Text.align(this.total);
         Graphic.mirror(this.back_button);
         Graphic.mirror(this.close_button);
         Graphic.mirror(this.window.masking);
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.divider.x = 96;
            this.pageup_button.x = 29;
            this.pagedown_button.x = 29;
            this.slider.x = 29;
            this.window.x = 95;
            this.total.x = 257;
            this.back_button.x = 630;
            this.close_button.x = 98;
            this.window.masking.x = 532;
         }
         else
         {
            this.divider.x = 542;
            this.pageup_button.x = 563;
            this.pagedown_button.x = 563;
            this.slider.x = 563;
            this.window.x = 10;
            this.total.x = 23;
            this.back_button.x = 10;
            this.close_button.x = 544;
            this.window.masking.x = 3;
         }
      }
   }
}

