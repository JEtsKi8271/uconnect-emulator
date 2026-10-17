package core.utils
{
   import core.locale.LocaleArchive;
   import flash.display.DisplayObject;
   
   public class Graphic
   {
      
      public function Graphic()
      {
         super();
      }
      
      public static function mirror(param1:DisplayObject) : void
      {
         if(LocaleArchive.getInstance().isMirrored())
         {
            if(param1.scaleX == 1)
            {
               param1.scaleX = -1;
            }
         }
         else if(param1.scaleX == -1)
         {
            param1.scaleX = 1;
         }
      }
   }
}

