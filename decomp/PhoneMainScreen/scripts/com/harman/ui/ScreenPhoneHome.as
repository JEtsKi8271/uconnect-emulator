package com.harman.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import skin.Skin;
   
   public dynamic class ScreenPhoneHome extends BaseMovieClip implements IMovieClip
   {
      
      public var display:MovieClip;
      
      public var displaySplit:MovieClip;
      
      public var DialButtonIconX1:int = 14;
      
      public var DialButtonLabelX1:int = 45;
      
      public var DialButtonIconX2:int = 9;
      
      public var DialButtonLabelX2:int = 40;
      
      public var DialButtonIconX3:int = 19;
      
      public var DialButtonLabelX3:int = 50;
      
      public var DialButtonIconX4:int = 29;
      
      public var DialButtonLabelX4:int = 60;
      
      public var LabelStatusX:int = 46;
      
      public var LabelStatusWidth:int = 228;
      
      public var Align_LabelStatus:int = 320;
      
      public var TransferButtonKoreanY:int = 2;
      
      public function ScreenPhoneHome()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.labelNotAvailable,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displayPrimaryPhone.labelPhoneName,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displayPrimaryPhone.labelCallTime,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displayPrimaryPhone.labelAction,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displayPrimaryPhone.labelStatus,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displayPrimaryPhone.labelRoaming,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displayPrimaryPhone.labelVR,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displayPrimaryPhone.missedCalls,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displayPrimaryPhone.missedTexts,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displaySecondaryPhone.labelActivity,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displaySecondaryPhone.labelNumber,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.displayPrimaryPhone.labelPhoneName,Skin.style.currentTheme.LCDText);
         Skin.style.applyStyle(this.displayPrimaryPhone.labelCallTime,Skin.style.currentTheme.LCDText);
         Skin.style.applyStyle(this.displayPrimaryPhone.labelAction,Skin.style.currentTheme.LCDText);
         Skin.style.applyStyle(this.displayPrimaryPhone.labelStatus,Skin.style.currentTheme.LCDText);
         Skin.style.applyStyle(this.displayPrimaryPhone.labelRoaming,Skin.style.currentTheme.LCDText);
         Skin.style.applyStyle(this.displaySecondaryPhone.labelActivity,Skin.style.currentTheme.LCDText);
         Skin.style.applyStyle(this.displaySecondaryPhone.labelNumber,Skin.style.currentTheme.LCDText);
      }
   }
}

