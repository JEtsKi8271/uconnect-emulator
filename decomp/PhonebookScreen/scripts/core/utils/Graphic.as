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
      
      public static function mirror(_this:DisplayObject) : void
      {
         if(LocaleArchive.getInstance().isMirrored())
         {
            if(_this.scaleX == 1)
            {
               _this.scaleX = -1;
            }
         }
         else if(_this.scaleX == -1)
         {
            _this.scaleX = 1;
         }
      }
   }
}

