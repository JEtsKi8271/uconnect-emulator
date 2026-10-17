package
{
   import com.harman.ui.ButtonSeek;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol146")]
   public dynamic class C_Button_SeekBackward_MediaHomeScreen extends ButtonSeek
   {
      
      public function C_Button_SeekBackward_MediaHomeScreen()
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

