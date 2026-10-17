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
   
   public dynamic class PhoneRecentCallsScreenViewMovieClip extends ScreenMovieClip
   {
      
      public var itemsInList_label:TextField;
      
      public var viewButtons_group:MovieClip;
      
      public function PhoneRecentCallsScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.itemsInList_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.itemsInList_label,Skin.style.currentTheme.primaryText);
      }
      
      public function updateCategoriesButtonLabel() : void
      {
         if(1 == this.viewButtons_group.allCalls_button.value_label.numLines)
         {
            this.viewButtons_group.allCalls_button.value_label.y = 20;
         }
         else
         {
            this.viewButtons_group.allCalls_button.value_label.y = 6;
         }
         if(1 == this.viewButtons_group.incomingCalls_button.value_label.numLines)
         {
            this.viewButtons_group.incomingCalls_button.value_label.y = 20;
         }
         else
         {
            this.viewButtons_group.incomingCalls_button.value_label.y = 6;
         }
         if(1 == this.viewButtons_group.outgoingCalls_button.value_label.numLines)
         {
            this.viewButtons_group.outgoingCalls_button.value_label.y = 20;
         }
         else
         {
            this.viewButtons_group.outgoingCalls_button.value_label.y = 6;
         }
         if(1 == this.viewButtons_group.missedCalls_button.value_label.numLines)
         {
            this.viewButtons_group.missedCalls_button.value_label.y = 20;
         }
         else
         {
            this.viewButtons_group.missedCalls_button.value_label.y = 6;
         }
      }
      
      override protected function updateAlignment() : void
      {
         Graphic.mirror(this.back_button);
         Graphic.mirror(this.close_button);
         Graphic.mirror(this.masking);
         Graphic.mirror(this.phone_scroller.thumb.popup_simple.smtriangle);
         this.formatListItem(this.phone_list.row_0_group);
         this.formatListItem(this.phone_list.row_1_group);
         this.formatListItem(this.phone_list.row_2_group);
         this.formatListItem(this.phone_list.row_3_group);
         this.formatListItem(this.phone_list.row_4_group);
         this.formatListItem(this.phone_list.row_5_group);
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.masking.x = 626;
            this.divider.x = 96;
            this.back_button.x = 630;
            this.close_button.x = 98;
            this.phone_scroller.x = 24;
            this.phone_scroller.thumb.popup_simple.x = 23;
            this.phone_scroller.thumb.popup_simple.smtriangle.x = 11;
            this.viewButtons_group.x = 543;
            Text.align(this.displayTitle.labelValue,TextFormatAlign.RIGHT);
         }
         else
         {
            this.masking.x = 13;
            this.divider.x = 542;
            this.back_button.x = 10;
            this.close_button.x = 544;
            this.phone_scroller.x = 558;
            this.phone_scroller.thumb.popup_simple.x = -117;
            this.phone_scroller.thumb.popup_simple.smtriangle.x = 103;
            this.viewButtons_group.x = 13;
            Text.align(this.displayTitle.labelValue,TextFormatAlign.LEFT);
         }
      }
      
      private function formatListItem(_button:MovieClip) : void
      {
         Graphic.mirror(_button.call_group.displayMore_icon);
         if(LocaleArchive.getInstance().isMirrored())
         {
            _button.options_button.x = 0;
            _button.call_group.displayMore_icon.x = 28;
            _button.call_group.callType_icon.x = 412;
            _button.call_group.nbrtype.x = 394;
            _button.call_group.name_label.x = 46;
            _button.details_group.select_label.x = 3;
            _button.details_group.numberType_icon.x = 417;
            _button.details_group.name_label.x = 134;
            _button.details_group.dial_group.x = 57;
            _button.details_group.dial_group.dial_icon.x = 0;
            _button.details_group.dial_group.dial_translate.x = 27;
            Text.align(_button.call_group.name_label,TextFormatAlign.RIGHT);
            Text.align(_button.details_group.name_label,TextFormatAlign.RIGHT);
         }
         else
         {
            _button.options_button.x = 389;
            _button.call_group.displayMore_icon.x = 418;
            _button.call_group.callType_icon.x = 7;
            _button.call_group.nbrtype.x = 50;
            _button.call_group.name_label.x = 68;
            _button.details_group.select_label.x = 373;
            _button.details_group.numberType_icon.x = 22;
            _button.details_group.name_label.x = 45;
            _button.details_group.dial_group.x = 287;
            _button.details_group.dial_group.dial_icon.x = 77;
            _button.details_group.dial_group.dial_translate.x = 0;
            Text.align(_button.call_group.name_label,TextFormatAlign.LEFT);
            Text.align(_button.details_group.name_label,TextFormatAlign.LEFT);
         }
      }
   }
}

