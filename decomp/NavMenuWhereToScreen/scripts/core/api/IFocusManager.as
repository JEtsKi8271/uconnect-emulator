package core.api
{
   import core.enums.FocusObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.IEventDispatcher;
   
   public interface IFocusManager extends IEventDispatcher
   {
      
      function init(param1:Sprite) : void;
      
      function get enabled() : Boolean;
      
      function set enabled(param1:Boolean) : void;
      
      function get cursorActive() : Boolean;
      
      function back() : Boolean;
      
      function exit() : Boolean;
      
      function getBorderObject() : MovieClip;
      
      function setBorderObject(param1:Object) : void;
      
      function deleteLayer(param1:String) : void;
      
      function rotaryTriggered(param1:int) : void;
      
      function selectTriggered(param1:Boolean) : void;
      
      function longPressTriggered() : void;
      
      function delFocus(param1:FocusObject) : void;
      
      function addFocus(param1:FocusObject) : void;
      
      function getFocus() : FocusObject;
      
      function setFocus(param1:String) : void;
      
      function refresh() : void;
   }
}

