package com.harman.ui
{
   import core.locale.LocaleArchive;
   import core.utils.Graphic;
   import core.utils.Text;
   import flash.text.TextFormatAlign;
   
   public class WindowSettings extends WindowMovieClip
   {
      
      public const LENGTH:int = 6;
      
      public var item0_button:ButtonListSettings;
      
      public var item1_button:ButtonListSettings;
      
      public var item2_button:ButtonListSettings;
      
      public var item3_button:ButtonListSettings;
      
      public var item4_button:ButtonListSettings;
      
      public var item5_button:ButtonListSettings;
      
      public function WindowSettings()
      {
         super();
         this.item0_button.sel = 0;
         this.item1_button.sel = 1;
         this.item2_button.sel = 2;
         this.item3_button.sel = 3;
         this.item4_button.sel = 4;
         this.item5_button.sel = 5;
      }
      
      public function updateAlignment() : void
      {
         this.formatListItem(this.item0_button);
         this.formatListItem(this.item1_button);
         this.formatListItem(this.item2_button);
         this.formatListItem(this.item3_button);
         this.formatListItem(this.item4_button);
         this.formatListItem(this.item5_button);
      }
      
      private function formatListItem(_this:ButtonListSettings) : void
      {
         Text.align(_this.label);
         Graphic.mirror(_this.arrow);
         if(LocaleArchive.getInstance().isMirrored())
         {
            _this.icon.x = 500;
            _this.arrow.x = 18;
            _this.value.x = 25;
            _this.check0.x = 44;
            _this.check1.x = 158;
            _this.check2.x = 272;
            _this.checkbox0.x = 5;
            _this.checkbox1.x = 119;
            _this.checkbox2.x = 233;
            _this.incrementer.x = 4;
            Text.align(_this.value,TextFormatAlign.LEFT);
            Text.align(_this.check0,TextFormatAlign.LEFT);
            Text.align(_this.check1,TextFormatAlign.LEFT);
            Text.align(_this.check2,TextFormatAlign.LEFT);
         }
         else
         {
            _this.icon.x = 6;
            _this.arrow.x = 512;
            _this.value.x = 205;
            _this.check0.x = 411;
            _this.check1.x = 297;
            _this.check2.x = 183;
            _this.checkbox0.x = 486;
            _this.checkbox1.x = 372;
            _this.checkbox2.x = 258;
            _this.incrementer.x = 392;
            Text.align(_this.value,TextFormatAlign.RIGHT);
            Text.align(_this.check0,TextFormatAlign.RIGHT);
            Text.align(_this.check1,TextFormatAlign.RIGHT);
            Text.align(_this.check2,TextFormatAlign.RIGHT);
         }
      }
   }
}

