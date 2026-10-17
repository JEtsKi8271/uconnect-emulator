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
   
   public dynamic class PlayerBrowseScreenViewMovieClip extends ScreenMovieClip
   {
      
      public var labelItemsInList:TextField;
      
      public var labelTextstartWidth:int = 410;
      
      public var labelTextWidth:int = 380;
      
      public function PlayerBrowseScreenViewMovieClip()
      {
         super();
      }
      
      public function get labelTextstartX() : int
      {
         return LocaleArchive.getInstance().isMirrored() ? 24 : 10;
      }
      
      public function get labelTextX() : int
      {
         return LocaleArchive.getInstance().isMirrored() ? 24 : 40;
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.searchDescription,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.labelItemsInList,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.labelItemsInList,Skin.style.currentTheme.primaryText);
      }
      
      override protected function updateAlignment() : void
      {
         Graphic.mirror(this.btnBack_button);
         Graphic.mirror(this.btnClose_button);
         Graphic.mirror(this.masking);
         this.formatListItem(this.browse_list.row_0_button);
         this.formatListItem(this.browse_list.row_1_button);
         this.formatListItem(this.browse_list.row_2_button);
         this.formatListItem(this.browse_list.row_3_button);
         this.formatListItem(this.browse_list.row_4_button);
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.searchDescription.x = 186;
            this.masking.x = 626;
            this.divider.x = 96;
            this.btnBack_button.x = 630;
            this.btnClose_button.x = 98;
            this.browse_scroller.x = 24;
            this.cat0_button.x = 543;
            this.cat1_button.x = 543;
            this.cat2_button.x = 543;
            this.cat3_button.x = 543;
            this.btnArrow_button.x = 543;
            this.btnClearResults_button.x = 98;
            this.btnSearch_button.x = 368;
            this.btnAlphaJump_button.x = 455;
            Text.align(this.displayTitle.labelValue,TextFormatAlign.RIGHT);
            Text.align(this.searchDescription,TextFormatAlign.RIGHT);
         }
         else
         {
            this.searchDescription.x = 107;
            this.masking.x = 13;
            this.divider.x = 542;
            this.btnBack_button.x = 10;
            this.btnClose_button.x = 544;
            this.browse_scroller.x = 558;
            this.cat0_button.x = 13;
            this.cat1_button.x = 13;
            this.cat2_button.x = 13;
            this.cat3_button.x = 13;
            this.btnArrow_button.x = 13;
            this.btnClearResults_button.x = 455;
            this.btnSearch_button.x = 185;
            this.btnAlphaJump_button.x = 98;
            Text.align(this.displayTitle.labelValue,TextFormatAlign.LEFT);
            Text.align(this.searchDescription,TextFormatAlign.LEFT);
         }
      }
      
      private function formatListItem(_button:MovieClip) : void
      {
         Graphic.mirror(_button.icon);
         Graphic.mirror(_button.displayMore);
         if(LocaleArchive.getInstance().isMirrored())
         {
            _button.type.x = 412;
            _button.icon.x = 444;
            _button.displayMore.x = 20;
            if(_button.type.visible)
            {
               _button.labelText.x = LocaleArchive.getInstance().isMirrored() ? 24 : 40;
            }
            else
            {
               _button.labelText.x = LocaleArchive.getInstance().isMirrored() ? 24 : 10;
            }
            Text.align(_button.labelText,TextFormatAlign.RIGHT);
         }
         else
         {
            _button.type.x = 8;
            _button.icon.x = 0;
            _button.displayMore.x = 424;
            if(_button.type.visible)
            {
               _button.labelText.x = LocaleArchive.getInstance().isMirrored() ? 24 : 40;
            }
            else
            {
               _button.labelText.x = LocaleArchive.getInstance().isMirrored() ? 24 : 10;
            }
            Text.align(_button.labelText,TextFormatAlign.LEFT);
         }
      }
   }
}

