package
{
   import com.nfuzion.display.ui.HVACFrontPanelButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol180")]
   public dynamic class btn_climate_settings_panel extends HVACFrontPanelButtonMovieClip
   {
      
      public function btn_climate_settings_panel()
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

