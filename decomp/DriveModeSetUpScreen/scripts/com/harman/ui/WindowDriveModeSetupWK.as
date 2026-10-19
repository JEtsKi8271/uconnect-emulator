package com.harman.ui
{
   import flash.display.MovieClip;
   
   public class WindowDriveModeSetupWK extends WindowMovieClip
   {
      
      public var option_Buttons_group1:GroupColorButtonF;
      
      public var option_Buttons_group2:GroupColorButton;
      
      public var option_Buttons_group3:GroupColorButton;
      
      public var option_Buttons_group4:GroupColorButton;
      
      public var option_Buttons_group5:GroupColorButton;
      
      public var option_Buttons_group6:GroupColorButton;
      
      public var option_Buttons_group7:GroupColorButton;
      
      private var offset:int = 2;
      
      public function WindowDriveModeSetupWK()
      {
         super();
      }
      
      public function set items(items:Array) : void
      {
         var clip:MovieClip = null;
         this.option_Buttons_group1.visible = false;
         this.option_Buttons_group2.visible = false;
         this.option_Buttons_group3.visible = false;
         this.option_Buttons_group4.visible = false;
         this.option_Buttons_group5.visible = false;
         this.option_Buttons_group6.visible = false;
         this.option_Buttons_group7.visible = false;
         for(var x:int = 0; x < items.length; x++)
         {
            if(Boolean(items[x].hasOwnProperty("isAWD")) && items[x].isAWD == true)
            {
               this.offset = 1;
               break;
            }
         }
         this.configureLayout(items);
         for(var i:int = 0; i < items.length; i++)
         {
            clip = this["option_Buttons_group" + (this.offset + i)];
            clip.visible = true;
            clip.title = items[i].title;
            clip.id = items[i].id;
            clip.labels = items[i].labels;
            clip.lockOut = items[i].lockOut;
            clip.enable = items[i].enable;
            clip.select = items[i].value;
            clip.setUp_center_button.visible = items[i].showMiddle;
            if(items[i].hasOwnProperty("colorBottom"))
            {
               clip.bottomColor = items[i].colorBottom;
            }
         }
      }
      
      private function configureLayout(items:Array) : void
      {
         switch(items.length)
         {
            case 1:
               this["option_Buttons_group" + this.offset].x = 259;
               break;
            case 2:
               this["option_Buttons_group" + this.offset].x = 186;
               this["option_Buttons_group" + (this.offset + 1)].x = 336;
               break;
            case 3:
               this["option_Buttons_group" + this.offset].x = 130;
               this["option_Buttons_group" + (this.offset + 1)].x = 259;
               this["option_Buttons_group" + (this.offset + 2)].x = 385;
               break;
            case 4:
               this["option_Buttons_group" + this.offset].x = 41;
               this["option_Buttons_group" + (this.offset + 1)].x = 186;
               this["option_Buttons_group" + (this.offset + 2)].x = 336;
               this["option_Buttons_group" + (this.offset + 3)].x = 477;
               break;
            case 5:
               this["option_Buttons_group" + this.offset].x = 3;
               this["option_Buttons_group" + (this.offset + 1)].x = 131;
               this["option_Buttons_group" + (this.offset + 2)].x = 259;
               this["option_Buttons_group" + (this.offset + 3)].x = 385;
               this["option_Buttons_group" + (this.offset + 4)].x = 508;
               break;
            case 6:
               this["option_Buttons_group" + this.offset].x = 0;
               this["option_Buttons_group" + (this.offset + 1)].x = 102;
               this["option_Buttons_group" + (this.offset + 2)].x = 204;
               this["option_Buttons_group" + (this.offset + 3)].x = 306;
               this["option_Buttons_group" + (this.offset + 4)].x = 408;
               this["option_Buttons_group" + (this.offset + 5)].x = 510;
         }
      }
   }
}

