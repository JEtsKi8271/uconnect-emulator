package com.harman.ui
{
   import core.locale.LocaleArchive;
   import core.utils.Graphic;
   import core.utils.Text;
   import flash.display.MovieClip;
   import skin.Skin;
   
   public class WindowDriveModeMainWK extends ButtonMovieClip
   {
      
      public var status1_display:TextGroup;
      
      public var status2_display:TextGroup;
      
      public var status3_display:TextGroup;
      
      public var status4_display:TextGroup;
      
      public var status5_display:TextGroup;
      
      public var status6_display:TextGroup;
      
      public function WindowDriveModeMainWK()
      {
         super();
      }
      
      public function set items(content:Array) : void
      {
         var group:MovieClip = null;
         var colorTransform:uint = 0;
         this.status1_display.visible = false;
         this.status2_display.visible = false;
         this.status3_display.visible = false;
         this.status4_display.visible = false;
         this.status5_display.visible = false;
         this.status6_display.visible = false;
         for(var i:int = 1; i <= content.length; i++)
         {
            group = this["status" + i + "_display"];
            group.visible = true;
            Text.truncateCharacters(group.label,Text.getText(content[i - 1].title));
            group.icon.visible = content[i - 1].error;
            Text.truncateCharacters(group.value,Text.getText(content[i - 1].value));
            if(content[i - 1].isEco)
            {
               colorTransform = 7601920;
            }
            else
            {
               colorTransform = uint(content[i - 1].color);
            }
            Skin.style.applyStyle(group.value_bg,{
               "method":"colorTransform",
               "alpha":1,
               "color":{
                  "hexValue":colorTransform,
                  "hue":0,
                  "saturation":100,
                  "brightness":100,
                  "contrast":0
               }
            });
            group.value_bg.visible = !content[i - 1].isOff;
         }
      }
      
      public function updateAlignment() : void
      {
         this.formatListItem(this.status1_display);
         this.formatListItem(this.status2_display);
         this.formatListItem(this.status3_display);
         this.formatListItem(this.status4_display);
         this.formatListItem(this.status5_display);
         this.formatListItem(this.status6_display);
      }
      
      protected function formatListItem(_row:TextGroup) : void
      {
         Graphic.mirror(_row.value_bg);
         Text.align(_row.value);
         if(LocaleArchive.getInstance().isMirrored())
         {
            _row.label.x = 88;
            _row.icon.x = 64;
            _row.value.x = 0;
            _row.value_bg.x = 97;
         }
         else
         {
            _row.label.x = 0;
            _row.icon.x = 150;
            _row.value.x = 175;
            _row.value_bg.x = 144;
         }
      }
   }
}

