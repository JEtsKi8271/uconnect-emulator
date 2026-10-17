package core.utils
{
   import core.enums.AppIcon;
   import flash.display.Loader;
   
   public class CustomLoader extends Loader
   {
      
      public var id:int;
      
      public var type:String;
      
      public var icon:AppIcon;
      
      public function CustomLoader()
      {
         super();
      }
   }
}

