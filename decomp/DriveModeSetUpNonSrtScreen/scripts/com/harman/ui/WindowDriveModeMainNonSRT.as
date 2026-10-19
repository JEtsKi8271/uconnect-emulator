package com.harman.ui
{
   import core.locale.LocaleArchive;
   import core.utils.Text;
   import flash.display.MovieClip;
   
   public class WindowDriveModeMainNonSRT extends ButtonMovieClip
   {
      
      public var status1_display:TextGroup;
      
      public var status2_display:TextGroup;
      
      public var status3_display:TextGroup;
      
      public var status4_display:TextGroup;
      
      public var status5_display:TextGroup;
      
      public function WindowDriveModeMainNonSRT()
      {
         super();
      }
      
      public function updateAlignment() : void
      {
         this.formatListItem(this.status1_display);
         this.formatListItem(this.status2_display);
         this.formatListItem(this.status3_display);
         this.formatListItem(this.status4_display);
         this.formatListItem(this.status5_display);
      }
      
      public function set items(content:Array) : void
      {
         var group:MovieClip = null;
         this.status1_display.visible = false;
         this.status2_display.visible = false;
         this.status3_display.visible = false;
         this.status4_display.visible = false;
         this.status5_display.visible = false;
         for(var i:int = 0; i < content.length; i++)
         {
            group = this["status" + (i + 1) + "_display"];
            group.visible = true;
            Text.truncateCharacters(group.label,Text.getText(content[i].title));
            group.icon.visible = content[i].error;
            Text.truncateCharacters(group.value,Text.getText(content[i].value));
         }
      }
      
      protected function formatListItem(_row:TextGroup) : void
      {
         Text.align(_row.value);
         if(LocaleArchive.getInstance().isMirrored())
         {
            _row.label.x = 100;
            _row.icon.x = 77;
            _row.value.x = 0;
         }
         else
         {
            _row.label.x = 0;
            _row.icon.x = 205;
            _row.value.x = 230;
         }
      }
   }
}

