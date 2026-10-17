package core.enums
{
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   
   public class AppIcon extends MovieClip
   {
      
      public var id:int;
      
      public var type:String;
      
      public var bmp:Bitmap = null;
      
      public var ok:Boolean = false;
      
      public var path:String = "";
      
      public var window:MovieClip;
      
      public function AppIcon()
      {
         super();
      }
   }
}

