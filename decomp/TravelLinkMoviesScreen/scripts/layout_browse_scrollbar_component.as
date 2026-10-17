package
{
   import com.nfuzion.display.ui.ScrollbarComponent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol87")]
   public dynamic class layout_browse_scrollbar_component extends ScrollbarComponent
   {
      
      public function layout_browse_scrollbar_component()
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

