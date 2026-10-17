package
{
   import com.harman.ui.CursorMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol12")]
   public dynamic class C_Cursor_BarCenter extends CursorMovieClip
   {
      
      public function C_Cursor_BarCenter()
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

