package com.harman.ui
{
   import skin.Skin;
   
   public dynamic class WindowAppsHome extends WindowMovieClip
   {
      
      public function WindowAppsHome()
      {
         super();
      }
      
      override public function set selected(select:int) : void
      {
         mSelected = select;
         if(this.numChildren > mSelected)
         {
            this.selectTarget = ButtonMovieClip(this.getChildAt(mSelected));
         }
      }
      
      override public function set selectTarget(selectTarget:ButtonMovieClip) : void
      {
         this.setCursorVisibility(false);
         mSelectTarget = selectTarget;
         this.setCursorVisibility(true);
      }
      
      override protected function setCursorVisibility(_visible:Boolean) : void
      {
         if(Boolean(mSelectTarget) && Boolean(mSelectTarget.hasOwnProperty("cursor")))
         {
            if(mFocus && _visible)
            {
               Skin.style.applyStyle(mSelectTarget.cursor,Skin.style.currentTheme.cursorGlow);
            }
            else
            {
               mSelectTarget.cursor.filters = [];
            }
         }
      }
      
      override public function set focus(_focus:Boolean) : void
      {
         mFocus = _focus;
         this.setCursorVisibility(mFocus);
      }
   }
}

