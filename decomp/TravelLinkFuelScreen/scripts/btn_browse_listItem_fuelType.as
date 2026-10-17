package
{
   import com.nfuzion.display.ui.ListItemFuelTypeButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol165")]
   public dynamic class btn_browse_listItem_fuelType extends ListItemFuelTypeButtonMovieClip
   {
      
      public function btn_browse_listItem_fuelType()
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

