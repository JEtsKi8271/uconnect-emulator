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
   
   public dynamic class PhonebookScreenViewMovieClip extends ScreenMovieClip
   {
      
      public var itemCount_label:TextField;
      
      public function PhonebookScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.searchDescription,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.itemCount_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.itemCount_label,Skin.style.currentTheme.primaryText);
      }
      
      override protected function updateAlignment() : void
      {
         Graphic.mirror(this.back_button);
         Graphic.mirror(this.close_button);
         Graphic.mirror(this.masking);
         Graphic.mirror(this.phonebook_scroller.thumb.popup_simple.smtriangle);
         this.formatListItem(this.phonebook_list.row_0_group);
         this.formatListItem(this.phonebook_list.row_1_group);
         this.formatListItem(this.phonebook_list.row_2_group);
         this.formatListItem(this.phonebook_list.row_3_group);
         this.formatListItem(this.phonebook_list.row_4_group);
         this.formatListItem(this.phonebook_list.row_5_group);
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.searchDescription.x = 186;
            this.masking.x = 626;
            this.divider.x = 96;
            this.back_button.x = 630;
            this.close_button.x = 98;
            this.phonebook_scroller.x = 24;
            this.phonebook_scroller.thumb.popup_simple.x = 23;
            this.phonebook_scroller.thumb.popup_simple.smtriangle.x = 11;
            this.mobile_button.x = 543;
            this.favorites_button.x = 543;
            this.btnClearResults_button.x = 98;
            this.search_button.x = 368;
            this.alpha_button.x = 455;
            this.cancel_button.x = 98;
            Text.align(this.title.labelValue,TextFormatAlign.RIGHT);
            Text.align(this.searchDescription,TextFormatAlign.RIGHT);
         }
         else
         {
            this.searchDescription.x = 107;
            this.masking.x = 13;
            this.divider.x = 542;
            this.back_button.x = 10;
            this.close_button.x = 544;
            this.phonebook_scroller.x = 558;
            this.phonebook_scroller.thumb.popup_simple.x = -117;
            this.phonebook_scroller.thumb.popup_simple.smtriangle.x = 103;
            this.mobile_button.x = 13;
            this.favorites_button.x = 13;
            this.btnClearResults_button.x = 455;
            this.search_button.x = this.alpha_button.visible ? 185 : 98;
            this.alpha_button.x = 98;
            this.cancel_button.x = 451;
            Text.align(this.title.labelValue,TextFormatAlign.LEFT);
            Text.align(this.searchDescription,TextFormatAlign.LEFT);
         }
      }
      
      private function formatListItem(_button:MovieClip) : void
      {
         Graphic.mirror(_button.contact_group.arrow);
         if(LocaleArchive.getInstance().isMirrored())
         {
            _button.options_button.x = 0;
            _button.contact_group.arrow.x = 28;
            _button.contact_group.name_label.x = 39;
            _button.select_label.x = 3;
            _button.detail_group.type_icon.x = 417;
            _button.detail_group.name_label.x = 158;
            _button.detail_group.call_widget.x = 57;
            _button.detail_group.call_widget.icon.x = 0;
            _button.detail_group.call_widget.value_label.x = 27;
            Text.align(_button.contact_group.name_label,TextFormatAlign.RIGHT);
            Text.align(_button.detail_group.name_label,TextFormatAlign.RIGHT);
         }
         else
         {
            _button.options_button.x = 389;
            _button.contact_group.arrow.x = 418;
            _button.contact_group.name_label.x = 10;
            _button.select_label.x = 373;
            _button.detail_group.type_icon.x = 22;
            _button.detail_group.name_label.x = 41;
            _button.detail_group.call_widget.x = 287;
            _button.detail_group.call_widget.icon.x = 77;
            _button.detail_group.call_widget.value_label.x = 0;
            Text.align(_button.contact_group.name_label,TextFormatAlign.LEFT);
            Text.align(_button.detail_group.name_label,TextFormatAlign.LEFT);
         }
      }
   }
}

