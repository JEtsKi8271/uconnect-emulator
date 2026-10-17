package
{
   import com.harman.ui.PresetsSat;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol70")]
   public dynamic class C_Presets_Satellite_SatHome extends PresetsSat
   {
      
      public function C_Presets_Satellite_SatHome()
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

