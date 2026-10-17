package core.utils
{
   import core.enums.AppIcon;
   import flash.net.URLLoader;
   
   public class CustomURLLoader extends URLLoader
   {
      
      public var id:int;
      
      public var type:String;
      
      public var icon:AppIcon;
      
      public function CustomURLLoader()
      {
         super();
      }
   }
}

