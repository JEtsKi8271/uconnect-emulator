package screens.NA_EU.RES_640x480
{
   import com.harman.framework.template.ScreenEnhanced;
   import flash.display.MovieClip;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ScreenCamera extends ScreenEnhanced
   {
      
      public function ScreenCamera()
      {
         mView = new MovieClip();
         super();
      }
   }
}

