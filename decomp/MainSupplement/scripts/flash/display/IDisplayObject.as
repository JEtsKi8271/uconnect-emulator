package flash.display
{
   import flash.accessibility.AccessibilityProperties;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Transform;
   import flash.geom.Vector3D;
   
   public interface IDisplayObject extends IEventDispatcher, IBitmapDrawable
   {
      
      function get accessibilityProperties() : AccessibilityProperties;
      
      function set accessibilityProperties(param1:AccessibilityProperties) : void;
      
      function get alpha() : Number;
      
      function set alpha(param1:Number) : void;
      
      function get blendMode() : String;
      
      function set blendMode(param1:String) : void;
      
      function set blendShader(param1:Shader) : void;
      
      function get cacheAsBitmap() : Boolean;
      
      function set cacheAsBitmap(param1:Boolean) : void;
      
      function get filters() : Array;
      
      function set filters(param1:Array) : void;
      
      function getBounds(param1:DisplayObject) : Rectangle;
      
      function getRect(param1:DisplayObject) : Rectangle;
      
      function globalToLocal(param1:Point) : Point;
      
      function globalToLocal3D(param1:Point) : Vector3D;
      
      function get height() : Number;
      
      function set height(param1:Number) : void;
      
      function hitTestObject(param1:DisplayObject) : Boolean;
      
      function hitTestPoint(param1:Number, param2:Number, param3:Boolean = false) : Boolean;
      
      function get loaderInfo() : LoaderInfo;
      
      function local3DToGlobal(param1:Vector3D) : Point;
      
      function localToGlobal(param1:Point) : Point;
      
      function get mask() : DisplayObject;
      
      function set mask(param1:DisplayObject) : void;
      
      function get mouseX() : Number;
      
      function get mouseY() : Number;
      
      function get name() : String;
      
      function set name(param1:String) : void;
      
      function get opaqueBackground() : Object;
      
      function set opaqueBackground(param1:Object) : void;
      
      function get parent() : DisplayObjectContainer;
      
      function get root() : DisplayObject;
      
      function get rotation() : Number;
      
      function set rotation(param1:Number) : void;
      
      function get rotationX() : Number;
      
      function set rotationX(param1:Number) : void;
      
      function get rotationY() : Number;
      
      function set rotationY(param1:Number) : void;
      
      function get rotationZ() : Number;
      
      function set rotationZ(param1:Number) : void;
      
      function get scale9Grid() : Rectangle;
      
      function set scale9Grid(param1:Rectangle) : void;
      
      function get scaleX() : Number;
      
      function set scaleX(param1:Number) : void;
      
      function get scaleY() : Number;
      
      function set scaleY(param1:Number) : void;
      
      function get scaleZ() : Number;
      
      function set scaleZ(param1:Number) : void;
      
      function get scrollRect() : Rectangle;
      
      function set scrollRect(param1:Rectangle) : void;
      
      function get stage() : Stage;
      
      function get transform() : Transform;
      
      function set transform(param1:Transform) : void;
      
      function get visible() : Boolean;
      
      function set visible(param1:Boolean) : void;
      
      function get width() : Number;
      
      function set width(param1:Number) : void;
      
      function get x() : Number;
      
      function set x(param1:Number) : void;
      
      function get y() : Number;
      
      function set y(param1:Number) : void;
      
      function get z() : Number;
      
      function set z(param1:Number) : void;
   }
}

