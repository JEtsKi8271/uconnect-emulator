package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import skin.Skin;
   
   public dynamic class HVACHomeScreenViewMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var display_group:MovieClip;
      
      public function HVACHomeScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.display_group.rearClimate_group.rear_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.display_group.frontClimateOff_group.off_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.display_group.rearClimateOff_group.off_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.display_group.rearClimate_group.rear_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.display_group.frontClimateOff_group.off_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.display_group.rearClimateOff_group.off_label,Skin.style.currentTheme.primaryText);
      }
      
      public function setControlsButtonType(Hs:Boolean, Hw:Boolean, Vs:Boolean) : void
      {
         var POS_THREEITEM_LEFT:int = 20;
         var POS_TWOITEM_LEFT:int = 40;
         var POS_CENTER:int = 76;
         var POS_TWOITEM_RIGHT:int = 106;
         var POS_THREEITEM_RIGHT:int = 131;
         this.display_group.frontClimate_group.controlLinkHsVsHst_button.visible = Hs || Hw || Vs;
         this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.visible = Hs || Hw || Vs;
         this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconHS.visible = Hs;
         this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconHW.visible = Hw;
         this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconVS.visible = Vs;
         this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconHS.visible = Hs;
         this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconHW.visible = Hw;
         this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconVS.visible = Vs;
         if(Hs && !Hw && !Vs)
         {
            this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconHS.x = POS_CENTER;
            this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconHS.x = POS_CENTER;
         }
         else if(Hs && Vs && !Hw)
         {
            this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconHS.x = POS_TWOITEM_LEFT;
            this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconVS.x = POS_TWOITEM_RIGHT;
            this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconHS.x = POS_TWOITEM_LEFT;
            this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconVS.x = POS_TWOITEM_RIGHT;
         }
         else if(Hs && Hw && !Vs)
         {
            this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconHS.x = POS_TWOITEM_LEFT;
            this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconHW.x = POS_TWOITEM_RIGHT;
            this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconHS.x = POS_TWOITEM_LEFT;
            this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconHW.x = POS_TWOITEM_RIGHT;
         }
         else if(Hs && Hw && Vs)
         {
            this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconHS.x = POS_THREEITEM_LEFT;
            this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconHW.x = POS_CENTER;
            this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconVS.x = POS_THREEITEM_RIGHT;
            this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconHS.x = POS_THREEITEM_LEFT;
            this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconHW.x = POS_CENTER;
            this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconVS.x = POS_THREEITEM_RIGHT;
         }
         else if(Vs && !Hs && !Hw)
         {
            this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconVS.x = POS_CENTER;
            this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconVS.x = POS_CENTER;
         }
         else if(Vs && Hw && !Hs)
         {
            this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconVS.x = POS_TWOITEM_LEFT;
            this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconHW.x = POS_TWOITEM_RIGHT;
            this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconVS.x = POS_TWOITEM_LEFT;
            this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconHW.x = POS_TWOITEM_RIGHT;
         }
         else if(Hw && !Hs && !Vs)
         {
            this.display_group.frontClimateOff_group.controlLinkHsVsHst_button.iconVS.x = POS_CENTER;
            this.display_group.frontClimate_group.controlLinkHsVsHst_button.iconVS.x = POS_CENTER;
         }
      }
   }
}

