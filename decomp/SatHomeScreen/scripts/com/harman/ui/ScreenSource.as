package com.harman.ui
{
   import events.WidgetEvent;
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   
   public dynamic class ScreenSource extends BaseMovieClip implements IMovieClip
   {
      
      public var group_sources:MovieClip;
      
      public function ScreenSource()
      {
         super();
         this.group_sources.addEventListener(WidgetEvent.VISIBILITY,this.onSourceVISIBILITY,true,0,true);
      }
      
      public function onSourceVISIBILITY(e:WidgetEvent) : void
      {
         var buttons:Array = new Array();
         for(var i:* = int(this.group_sources.numChildren - 1); i >= 0; i--)
         {
            if(this.group_sources.getChildAt(i).visible == true)
            {
               buttons.push(this.group_sources.getChildAt(i));
            }
         }
         switch(buttons.length)
         {
            case 4:
               buttons[0].y = 101;
               buttons[1].y = 158;
               buttons[2].y = 215;
               buttons[3].y = 271;
               break;
            case 3:
               buttons[0].y = 121;
               buttons[1].y = 188;
               buttons[2].y = 255;
               break;
            case 2:
               buttons[0].y = 138;
               buttons[1].y = 228;
               break;
            case 1:
               buttons[0].y = 188;
         }
      }
   }
}

