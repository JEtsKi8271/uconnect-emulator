package
{
   import com.harman.ui.GraphicBarHighlight;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol176")]
   public dynamic class C_Graphic_Titlebar_1px_MediaHomeScreen extends GraphicBarHighlight
   {
      
      public function C_Graphic_Titlebar_1px_MediaHomeScreen()
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

