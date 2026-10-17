package com.harman.ui
{
   import core.locale.LocaleArchive;
   import core.utils.Graphic;
   import core.utils.Text;
   import skin.Skin;
   
   public dynamic class ListApps extends ScreenMovieClip
   {
      
      public function ListApps()
      {
         super();
      }
      
      public function updateTitle() : void
      {
         this.updateAlignment();
      }
      
      override protected function updateAlignment() : void
      {
         Text.align(this.title.label);
         Text.align(this.title.status);
         Text.align(this.total);
         this.window.updateWindowAlignment();
         Graphic.mirror(this.back_button);
         Graphic.mirror(this.close_button);
         Graphic.mirror(this.window.masking);
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.title.label.x = this.title.status.visible ? 157 : 6;
            this.title.label.width = this.title.status.visible ? 285 : 437;
            this.title.status.x = 6;
            this.divider.x = 96;
            this.pageup_button.x = 29;
            this.pagedown_button.x = 29;
            this.slider.x = 29;
            this.window.x = 95;
            this.total.x = 250;
            this.back_button.x = 630;
            this.close_button.x = 98;
            this.window.masking.x = 532;
         }
         else
         {
            this.title.label.x = 6;
            this.title.label.width = this.title.status.visible ? 285 : 437;
            this.title.status.x = 292;
            this.divider.x = 542;
            this.pageup_button.x = 563;
            this.pagedown_button.x = 563;
            this.slider.x = 563;
            this.window.x = 13;
            this.total.x = 100;
            this.back_button.x = 10;
            this.close_button.x = 544;
            this.window.masking.x = 0;
         }
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.total,Skin.style.currentTheme.FONT_PRIMARY);
      }
   }
}

