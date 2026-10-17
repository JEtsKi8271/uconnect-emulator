package
{
   import com.nfuzion.display.ui.ButtonMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol128")]
   public dynamic class Button_Category_Top_BrowseAll extends ButtonMovieClip
   {
      
      public function Button_Category_Top_BrowseAll()
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

