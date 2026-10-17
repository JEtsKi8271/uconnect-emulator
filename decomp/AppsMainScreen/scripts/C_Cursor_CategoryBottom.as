package
{
   import com.harman.ui.CursorMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol62")]
   public dynamic class C_Cursor_CategoryBottom extends CursorMovieClip
   {
      
      public function C_Cursor_CategoryBottom()
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

