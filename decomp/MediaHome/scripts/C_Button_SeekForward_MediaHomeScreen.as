package
{
   import com.harman.ui.ButtonSeek;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol139")]
   public dynamic class C_Button_SeekForward_MediaHomeScreen extends ButtonSeek
   {
      
      public function C_Button_SeekForward_MediaHomeScreen()
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

