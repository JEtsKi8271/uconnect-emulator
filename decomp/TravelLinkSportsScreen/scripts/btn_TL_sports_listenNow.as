package
{
   import com.nfuzion.display.ui.ButtonListenNow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol101")]
   public dynamic class btn_TL_sports_listenNow extends ButtonListenNow
   {
      
      public function btn_TL_sports_listenNow()
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

