package
{
   import com.nfuzion.display.ui.HVACFrontPanelButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol173")]
   public dynamic class btn_climate_settings_floor extends HVACFrontPanelButtonMovieClip
   {
      
      public function btn_climate_settings_floor()
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

