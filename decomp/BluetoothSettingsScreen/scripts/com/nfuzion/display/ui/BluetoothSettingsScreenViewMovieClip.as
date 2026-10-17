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
   
   public dynamic class BluetoothSettingsScreenViewMovieClip extends ScreenMovieClip
   {
      
      public var viewButtons_group:MovieClip;
      
      public var itemsInList_label:TextField;
      
      public var bluetooth_scroller:ScrollbarComponent;
      
      public var back_button:ButtonMovieClip;
      
      public var close_button:ButtonMovieClip;
      
      public var changePin_button:ButtonMovieClip;
      
      public var addDevice_button:ButtonMovieClip;
      
      public var bluetooth_list:MovieClip;
      
      public function BluetoothSettingsScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.itemsInList_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.notification.label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.itemsInList_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.notification.label,Skin.style.currentTheme.primaryText);
      }
      
      override protected function updateAlignment() : void
      {
         Graphic.mirror(this.back_button);
         Graphic.mirror(this.close_button);
         Graphic.mirror(this.masking);
         this.formatListItem(this.bluetooth_list.row_0_group);
         this.formatListItem(this.bluetooth_list.row_1_group);
         this.formatListItem(this.bluetooth_list.row_2_group);
         this.formatListItem(this.bluetooth_list.row_3_group);
         this.formatListItem(this.bluetooth_list.row_4_group);
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.masking.x = 626;
            this.divider.x = 96;
            this.back_button.x = 630;
            this.close_button.x = 98;
            this.bluetooth_scroller.x = 24;
            this.viewButtons_group.x = 543;
            this.changePin_button.x = 368;
            this.addDevice_button.x = 455;
            Text.align(this.displayTitle.labelValue,TextFormatAlign.RIGHT);
         }
         else
         {
            this.masking.x = 13;
            this.divider.x = 542;
            this.back_button.x = 10;
            this.close_button.x = 544;
            this.bluetooth_scroller.x = 558;
            this.viewButtons_group.x = 13;
            this.changePin_button.x = 185;
            this.addDevice_button.x = 98;
            Text.align(this.displayTitle.labelValue,TextFormatAlign.LEFT);
         }
      }
      
      public function formatListItem(_button:MovieClip, _connected:Boolean = false) : void
      {
         if(LocaleArchive.getInstance().isMirrored())
         {
            _button.options_button.x = 5;
            _button.device_button.number_label.x = 395;
            _button.device_button.name_label.x = _connected ? 204 : 56;
            _button.device_button.name_label.width = _connected ? 190 : 335;
            _button.device_button.status_label.x = 56;
            Text.align(_button.device_button.number_label,TextFormatAlign.LEFT);
            Text.align(_button.device_button.name_label,TextFormatAlign.RIGHT);
            Text.align(_button.device_button.status_label,TextFormatAlign.LEFT);
         }
         else
         {
            _button.options_button.x = 401;
            _button.device_button.number_label.x = 1;
            _button.device_button.name_label.x = 50;
            _button.device_button.name_label.width = _connected ? 217 : 335;
            _button.device_button.status_label.x = 243;
            Text.align(_button.device_button.number_label,TextFormatAlign.RIGHT);
            Text.align(_button.device_button.name_label,TextFormatAlign.LEFT);
            Text.align(_button.device_button.status_label,TextFormatAlign.RIGHT);
         }
      }
   }
}

