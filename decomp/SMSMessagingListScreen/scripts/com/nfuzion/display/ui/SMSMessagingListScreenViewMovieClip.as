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
   
   public dynamic class SMSMessagingListScreenViewMovieClip extends ScreenMovieClip
   {
      
      public var sideButtons_group:MovieClip;
      
      public var displays_group:MovieClip;
      
      public var itemsInList_label:TextField;
      
      public var displayTitle:DisplayTitleMovieClip;
      
      public var close_button:ButtonMovieClip;
      
      public var back_button:ButtonMovieClip;
      
      public function SMSMessagingListScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.itemsInList_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.itemsInList_label,Skin.style.currentTheme.primaryText);
      }
      
      override protected function updateAlignment() : void
      {
         Graphic.mirror(this.back_button);
         Graphic.mirror(this.close_button);
         Graphic.mirror(this.masking);
         this.formatListItem(this.displays_group.inBox_group.browse_list.row_0_group);
         this.formatListItem(this.displays_group.inBox_group.browse_list.row_1_group);
         this.formatListItem(this.displays_group.inBox_group.browse_list.row_2_group);
         this.formatListItem(this.displays_group.inBox_group.browse_list.row_3_group);
         this.formatListItem(this.displays_group.inBox_group.browse_list.row_4_group);
         this.formatListItem(this.displays_group.inBox_group.browse_list.row_5_group);
         this.formatMessageItem(this.displays_group.newMessage_group.browse_list.row_0_group.row_button);
         this.formatMessageItem(this.displays_group.newMessage_group.browse_list.row_1_group.row_button);
         this.formatMessageItem(this.displays_group.newMessage_group.browse_list.row_2_group.row_button);
         this.formatMessageItem(this.displays_group.newMessage_group.browse_list.row_3_group.row_button);
         this.formatMessageItem(this.displays_group.newMessage_group.browse_list.row_4_group.row_button);
         this.formatMessageItem(this.displays_group.newMessage_group.browse_list.row_5_group.row_button);
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.divider.x = 96;
            this.masking.x = 626;
            this.back_button.x = 630;
            this.close_button.x = 98;
            this.sideButtons_group.x = 543;
            this.displays_group.newMessage_group.browse_scroller.x = 24;
            this.displays_group.newMessage_group.browse_scroller.thumb.popup_simple.x = 23;
            this.displays_group.newMessage_group.browse_scroller.thumb.popup_simple.smtriangle.x = 11;
            this.displays_group.inBox_group.browse_scroller.x = 24;
            this.displays_group.inBox_group.browse_scroller.thumb.popup_simple.x = 23;
            this.displays_group.inBox_group.browse_scroller.thumb.popup_simple.smtriangle.x = 11;
            Text.align(this.displayTitle.labelValue,TextFormatAlign.RIGHT);
         }
         else
         {
            this.divider.x = 542;
            this.masking.x = 13;
            this.back_button.x = 10;
            this.close_button.x = 544;
            this.sideButtons_group.x = 13;
            this.displays_group.newMessage_group.browse_scroller.x = 558;
            this.displays_group.newMessage_group.browse_scroller.thumb.popup_simple.x = -117;
            this.displays_group.newMessage_group.browse_scroller.thumb.popup_simple.smtriangle.x = 103;
            this.displays_group.inBox_group.browse_scroller.x = 558;
            this.displays_group.inBox_group.browse_scroller.thumb.popup_simple.x = -117;
            this.displays_group.inBox_group.browse_scroller.thumb.popup_simple.smtriangle.x = 103;
            Text.align(this.displayTitle.labelValue,TextFormatAlign.LEFT);
         }
      }
      
      private function formatListItem(_button:MovieClip) : void
      {
         if(LocaleArchive.getInstance().isMirrored())
         {
            _button.listen_button.x = 87;
            _button.view_button.x = 0;
            _button.row_button.x = 174;
            _button.row_button.value_label.x = 3;
            _button.row_button.noItems_label.x = 3;
            _button.row_button.readMail.x = 227;
            _button.row_button.unreadMail.x = 227;
            Text.align(_button.row_button.value_label,TextFormatAlign.RIGHT);
            Text.align(_button.row_button.noItems_label,TextFormatAlign.RIGHT);
         }
         else
         {
            _button.listen_button.x = 270;
            _button.view_button.x = 357;
            _button.row_button.x = 0;
            _button.row_button.value_label.x = 55;
            _button.row_button.noItems_label.x = 9;
            _button.row_button.readMail.x = 14;
            _button.row_button.unreadMail.x = 14;
            Text.align(_button.row_button.value_label,TextFormatAlign.LEFT);
            Text.align(_button.row_button.noItems_label,TextFormatAlign.LEFT);
         }
      }
      
      private function formatMessageItem(_button:MovieClip) : void
      {
         Graphic.mirror(_button.arrow);
         if(LocaleArchive.getInstance().isMirrored())
         {
            _button.arrow.x = 18;
            _button.value_label.x = 22;
            Text.align(_button.value_label,TextFormatAlign.RIGHT);
         }
         else
         {
            _button.arrow.x = 427;
            _button.value_label.x = 10;
            Text.align(_button.value_label,TextFormatAlign.LEFT);
         }
      }
   }
}

