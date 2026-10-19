package com.harman.ui
{
   import core.utils.Text;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class DriveModeLaunchControlScreenViewMovieClip extends ScreenMovieClip
   {
      
      public var launchLabelA:TextField;
      
      public var launchLabelB:TextField;
      
      public var maximum:TextField;
      
      public var minimum:TextField;
      
      public var label:TextField;
      
      public function DriveModeLaunchControlScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateAlignment() : void
      {
         Text.align(this.title_group1.displayTitle.label);
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.launchLabelA,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.launchLabelB,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.maximum,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.minimum,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.slider.thumb.rpm.label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.launchLabelA,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.launchLabelB,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.maximum,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.minimum,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.slider.thumb.rpm.label,Skin.style.currentTheme.primaryText);
      }
   }
}

