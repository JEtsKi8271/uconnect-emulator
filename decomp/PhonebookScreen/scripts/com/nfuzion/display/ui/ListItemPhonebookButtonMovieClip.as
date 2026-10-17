package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemPhonebookButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var select_label:TextField;
      
      public var detail_group:MovieClip;
      
      public var contact_group:MovieClip;
      
      public function ListItemPhonebookButtonMovieClip()
      {
         super();
         this.select_label.mouseEnabled = false;
         this.detail_group.mouseEnabled = false;
         this.detail_group.mouseChildren = false;
         this.contact_group.mouseEnabled = false;
         this.contact_group.mouseChildren = false;
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.select_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.detail_group.name_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.detail_group.call_widget.call_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.contact_group.name_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.select_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.detail_group.name_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.detail_group.call_widget.call_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.contact_group.name_label,Skin.style.currentTheme.primaryText);
      }
   }
}

