package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class DetailedInfoMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var row1column1_label:TextField;
      
      public var row1column2_label:TextField;
      
      public var row2column1_label:TextField;
      
      public var row2column2_label:TextField;
      
      public var row3column1_label:TextField;
      
      public var row3column2_label:TextField;
      
      public var row4column1_label:TextField;
      
      public var row4column2_label:TextField;
      
      public var row5column1_label:TextField;
      
      public var row5column2_label:TextField;
      
      public function DetailedInfoMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.row1column1_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.row1column2_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.row2column1_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.row2column2_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.row3column1_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.row3column2_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.row4column1_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.row4column2_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.row5column1_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.row5column2_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.row1column1_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.row1column2_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.row2column1_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.row2column2_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.row3column1_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.row3column2_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.row4column1_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.row4column2_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.row5column1_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.row5column2_label,Skin.style.currentTheme.primaryText);
      }
   }
}

