package
{
   import com.nfuzion.display.ui.CheckBoxButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol126")]
   public dynamic class btn_browse_list_checkBox extends CheckBoxButtonMovieClip
   {
      
      public function btn_browse_list_checkBox()
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

