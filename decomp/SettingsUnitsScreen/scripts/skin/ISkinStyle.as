package skin
{
   import core.theme.ThemeObject;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public interface ISkinStyle
   {
      
      function get currentTheme() : ThemeObject;
      
      function applyStyle(param1:DisplayObject, param2:Object) : void;
      
      function applyFont(param1:TextField, param2:String) : void;
      
      function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void;
      
      function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void;
      
      function getValuesFromThemeSWF(param1:MovieClip) : void;
      
      function dispatchEvent(param1:Event) : Boolean;
   }
}

