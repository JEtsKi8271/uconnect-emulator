package com.harman.ui
{
   import core.locale.LocaleArchive;
   import flash.events.Event;
   
   public dynamic class ScreenMovieClip extends BaseMovieClip
   {
      
      public function ScreenMovieClip()
      {
         super();
         LocaleArchive.getInstance().addEventListener(LocaleArchive.getInstance().EVT_LANGUAGE_CHANGED(),this.onLanguageChange,false,10,true);
         this.updateAlignment();
      }
      
      protected function updateAlignment() : void
      {
      }
      
      protected function onLanguageChange(e:Event) : void
      {
         this.updateAlignment();
      }
   }
}

