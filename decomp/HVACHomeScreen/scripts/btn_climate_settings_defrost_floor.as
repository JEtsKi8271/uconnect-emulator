package
{
   import com.nfuzion.display.ui.HVACFrontPanelButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol238")]
   public dynamic class btn_climate_settings_defrost_floor extends HVACFrontPanelButtonMovieClip
   {
      
      public function btn_climate_settings_defrost_floor()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame10() : *
      {
         stop();
      }
   }
}

