package com.nfuzion.display.ui
{
   import com.harman.ui.ScreenMovieClip;
   import core.locale.LocaleArchive;
   import core.utils.Text;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   import skin.Skin;
   
   public dynamic class SMSMessagePreviewPopupViewMovieClip extends ScreenMovieClip
   {
      
      public var title_label:TextField;
      
      public var messageTitle_label:TextField;
      
      public var typeTitle:MovieClip;
      
      public var iconEnvelope:MovieClip;
      
      public var messageBody_label:TextField;
      
      public var buttons_group:MovieClip;
      
      public function SMSMessagePreviewPopupViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.title_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.messageTitle_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.messageBody_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.messageTitle_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.messageBody_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.title_label,Skin.style.currentTheme.titleText);
         Skin.style.applyStyle(this.iconEnvelope,Skin.style.currentTheme.activeGraphic);
         Skin.style.applyStyle(this.typeTitle,Skin.style.currentTheme.activeGraphic);
      }
      
      override protected function updateAlignment() : void
      {
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.close_button.x = 22;
            this.iconEnvelope.x = 581;
            this.title_label.x = 86;
            this.messageTitle_label.x = 35;
            this.messageBody_label.x = 35;
            this.typeBody.x = 587;
            Text.align(this.title_label,TextFormatAlign.RIGHT);
            Text.align(this.messageTitle_label,TextFormatAlign.RIGHT);
            Text.align(this.messageBody_label,TextFormatAlign.RIGHT);
         }
         else
         {
            this.close_button.x = 564;
            this.iconEnvelope.x = 30;
            this.title_label.x = 65;
            this.messageTitle_label.x = 65;
            this.messageBody_label.x = 65;
            this.typeBody.x = 46;
            Text.align(this.title_label,TextFormatAlign.LEFT);
            Text.align(this.messageTitle_label,TextFormatAlign.LEFT);
            Text.align(this.messageBody_label,TextFormatAlign.LEFT);
         }
      }
   }
}

