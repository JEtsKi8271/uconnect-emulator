package flash.display
{
   import flash.geom.Rectangle;
   import flash.media.SoundTransform;
   
   public interface ISprite extends IDisplayObjectContainer
   {
      
      function get buttonMode() : Boolean;
      
      function set buttonMode(param1:Boolean) : void;
      
      function get dropTarget() : DisplayObject;
      
      function get graphics() : Graphics;
      
      function get hitArea() : Sprite;
      
      function set hitArea(param1:Sprite) : void;
      
      function get soundTransform() : SoundTransform;
      
      function set soundTransform(param1:SoundTransform) : void;
      
      function startDrag(param1:Boolean = false, param2:Rectangle = null) : void;
      
      function startTouchDrag(param1:int, param2:Boolean = false, param3:Rectangle = null) : void;
      
      function stopDrag() : void;
      
      function stopTouchDrag(param1:int) : void;
      
      function get useHandCursor() : Boolean;
      
      function set useHandCursor(param1:Boolean) : void;
   }
}

