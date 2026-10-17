package flash.display
{
   import flash.geom.Point;
   import flash.text.TextSnapshot;
   
   public interface IDisplayObjectContainer extends IInteractiveObject
   {
      
      function addChild(param1:DisplayObject) : DisplayObject;
      
      function addChildAt(param1:DisplayObject, param2:int) : DisplayObject;
      
      function areInaccessibleObjectsUnderPoint(param1:Point) : Boolean;
      
      function contains(param1:DisplayObject) : Boolean;
      
      function getChildAt(param1:int) : DisplayObject;
      
      function getChildByName(param1:String) : DisplayObject;
      
      function getChildIndex(param1:DisplayObject) : int;
      
      function getObjectsUnderPoint(param1:Point) : Array;
      
      function get mouseChildren() : Boolean;
      
      function set mouseChildren(param1:Boolean) : void;
      
      function get numChildren() : int;
      
      function removeChild(param1:DisplayObject) : DisplayObject;
      
      function removeChildAt(param1:int) : DisplayObject;
      
      function setChildIndex(param1:DisplayObject, param2:int) : void;
      
      function swapChildren(param1:DisplayObject, param2:DisplayObject) : void;
      
      function swapChildrenAt(param1:int, param2:int) : void;
      
      function get tabChildren() : Boolean;
      
      function set tabChildren(param1:Boolean) : void;
      
      function get textSnapshot() : TextSnapshot;
   }
}

