package
{
   import com.harman.ui.GraphicBarHighlight;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol29")]
   public dynamic class C_Graphic_Titlebar_1px_SatHome extends GraphicBarHighlight
   {
      
      public function C_Graphic_Titlebar_1px_SatHome()
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

