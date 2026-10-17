package
{
   import com.harman.ui.ButtonSplitSource;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol41")]
   public dynamic class C_Button_Map_MediaHomeScreen extends ButtonSplitSource
   {
      
      public function C_Button_Map_MediaHomeScreen()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

