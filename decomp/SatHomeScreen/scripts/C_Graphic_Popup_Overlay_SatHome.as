package
{
   import com.harman.ui.GraphicMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol130")]
   public dynamic class C_Graphic_Popup_Overlay_SatHome extends GraphicMovieClip
   {
      
      public function C_Graphic_Popup_Overlay_SatHome()
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

