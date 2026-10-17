package
{
   import com.harman.ui.ButtonBarActive;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol162")]
   public dynamic class C_Button_RSE_MediaHomeScreen extends ButtonBarActive
   {
      
      public function C_Button_RSE_MediaHomeScreen()
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

