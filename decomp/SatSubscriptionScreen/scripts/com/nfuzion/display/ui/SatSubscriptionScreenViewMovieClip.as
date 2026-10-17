package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class SatSubscriptionScreenViewMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var SubscriptionStatusTitle_translate:TextField;
      
      public var sub_SatRadio_translate:TextField;
      
      public var sub_RealTimeTraffic_translate:TextField;
      
      public var sub_TravelLink_translate:TextField;
      
      public var sub_BackseatTV_translate:TextField;
      
      public var CallSiriusNumber_translate:TextField;
      
      public var SiriusIDDesc_translate:TextField;
      
      public var SiriusBackseatIDDesc_translate:TextField;
      
      public var SiriusID_translate:TextField;
      
      public var SiriusBackseatID_translate:TextField;
      
      public var SiriusServicesDescription_translate:TextField;
      
      public var SiriusRealTimeTrafficDescription_translate:TextField;
      
      public var SiriusTravelLinkDescription_translate:TextField;
      
      public var SiriusBackseatTvDescription_translate:TextField;
      
      public function SatSubscriptionScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.SubscriptionStatusTitle_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.sub_SatRadio_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.sub_RealTimeTraffic_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.sub_TravelLink_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.sub_BackseatTV_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.CallSiriusNumber_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.SiriusIDDesc_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.SiriusBackseatIDDesc_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.SiriusID_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.SiriusBackseatID_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.SiriusServicesDescription_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.SiriusRealTimeTrafficDescription_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.SiriusTravelLinkDescription_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.SiriusBackseatTvDescription_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.SubscriptionStatusTitle_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.sub_SatRadio_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.sub_RealTimeTraffic_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.sub_TravelLink_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.sub_BackseatTV_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.CallSiriusNumber_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.SiriusIDDesc_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.SiriusBackseatIDDesc_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.SiriusID_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.SiriusBackseatID_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.SiriusServicesDescription_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.SiriusRealTimeTrafficDescription_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.SiriusTravelLinkDescription_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.SiriusBackseatTvDescription_translate,Skin.style.currentTheme.primaryText);
      }
   }
}

