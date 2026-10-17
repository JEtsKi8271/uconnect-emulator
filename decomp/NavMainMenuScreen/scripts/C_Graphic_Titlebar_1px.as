package
{
   import com.harman.ui.GraphicBarHighlight;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol51")]
   public dynamic class C_Graphic_Titlebar_1px extends GraphicBarHighlight
   {
      
      public function C_Graphic_Titlebar_1px()
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

