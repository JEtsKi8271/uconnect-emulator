package com.harman.ui
{
   import core.locale.LocaleArchive;
   import core.utils.Text;
   
   public class WindowApps extends WindowMovieClip
   {
      
      private var mItems:Array = null;
      
      public const MAX_ITEMS:int = 6;
      
      public const Y_POSITION:int = 18;
      
      public const NBRLINES_1:int = 20;
      
      public const NBRLINES_2:int = 40;
      
      public const NBRLINES_3:int = 60;
      
      public var cat0_button:ButtonCategory;
      
      public var cat1_button:ButtonCategory;
      
      public var cat2_button:ButtonCategory;
      
      public var cat3_button:ButtonCategory;
      
      public var cat4_button:ButtonCategory;
      
      public var item0_button:ButtonListApplication;
      
      public var item1_button:ButtonListApplication;
      
      public var item2_button:ButtonListApplication;
      
      public var item3_button:ButtonListApplication;
      
      public var item4_button:ButtonListApplication;
      
      public var item5_button:ButtonListApplication;
      
      public var opt0_button:ButtonAppFavorite;
      
      public var opt1_button:ButtonAppFavorite;
      
      public var opt2_button:ButtonAppFavorite;
      
      public var opt3_button:ButtonAppFavorite;
      
      public var opt4_button:ButtonAppFavorite;
      
      public var opt5_button:ButtonAppFavorite;
      
      public function WindowApps()
      {
         super();
         this.item0_button.sel = 0;
         this.item1_button.sel = 1;
         this.item2_button.sel = 2;
         this.item3_button.sel = 3;
         this.item4_button.sel = 4;
         this.item5_button.sel = 5;
      }
      
      public function updateWindowAlignment() : void
      {
         this.formatListItem(this.item0_button);
         this.formatListItem(this.item1_button);
         this.formatListItem(this.item2_button);
         this.formatListItem(this.item3_button);
         this.formatListItem(this.item4_button);
         this.formatListItem(this.item5_button);
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.cat0_button.x = 447;
            this.cat1_button.x = 447;
            this.cat2_button.x = 447;
            this.cat3_button.x = 447;
            this.cat4_button.x = 447;
            this.opt0_button.x = 6;
            this.opt1_button.x = 6;
            this.opt2_button.x = 6;
            this.opt3_button.x = 6;
            this.opt4_button.x = 6;
         }
         else
         {
            this.cat0_button.x = 0;
            this.cat1_button.x = 0;
            this.cat2_button.x = 0;
            this.cat3_button.x = 0;
            this.cat4_button.x = 0;
            this.opt0_button.x = 486;
            this.opt1_button.x = 486;
            this.opt2_button.x = 486;
            this.opt3_button.x = 486;
            this.opt4_button.x = 486;
         }
      }
      
      public function set items(items:Array) : void
      {
         this.mItems = items;
         var i:int = 0;
         while(i < this.MAX_ITEMS)
         {
            if(i < items.length)
            {
               if(items[i].select != "")
               {
                  this.formatListItem(this["item" + i + "_button"],true);
                  this["item" + i + "_button"].id = items[i].id;
                  this["item" + i + "_button"].window.visible = true;
                  Text.format(this["item" + i + "_button"].label,items[i].label);
                  Text.format(this["item" + i + "_button"].select,items[i].select);
                  this["item" + i + "_button"].setEnabled(true);
                  this["opt" + i + "_button"].visible = false;
               }
               else
               {
                  this.formatListItem(this["item" + i + "_button"],false);
                  if(items[i].appId == "new")
                  {
                     this["item" + i + "_button"].id = items[i].id;
                     this["item" + i + "_button"].window.visible = false;
                     Text.format(this["item" + i + "_button"].label,items[i].label);
                     this["item" + i + "_button"].select.text = "";
                     this["item" + i + "_button"].setEnabled(true);
                     this["opt" + i + "_button"].visible = false;
                  }
                  else
                  {
                     this["item" + i + "_button"].id = items[i].id;
                     this["item" + i + "_button"].window.visible = true;
                     Text.format(this["item" + i + "_button"].label,items[i].label);
                     this["item" + i + "_button"].select.text = "";
                     this["item" + i + "_button"].setEnabled(true);
                     this["opt" + i + "_button"].visible = true;
                  }
               }
            }
            else
            {
               this["item" + i + "_button"].id = -1;
               this["item" + i + "_button"].window.visible = false;
               this["item" + i + "_button"].label.text = "";
               this["item" + i + "_button"].select.text = "";
               this["item" + i + "_button"].setEnabled(false);
               this["opt" + i + "_button"].visible = false;
            }
            i++;
         }
         this.mItems = null;
      }
      
      public function set categories(categories:Array) : void
      {
         for(var i:int = 0; i < categories.length; i++)
         {
            this["cat" + i + "_button"].id = categories[i].id;
            Text.format(this["cat" + i + "_button"].label,categories[i].label,false);
            this["cat" + i + "_button"].setHighlight(categories[i].active);
            switch(this["cat" + i + "_button"].label.numLines)
            {
               case 1:
                  this["cat" + i + "_button"].label.y = this.Y_POSITION;
                  this["cat" + i + "_button"].label.height = this.NBRLINES_1;
                  break;
               case 2:
                  this["cat" + i + "_button"].label.y = this.Y_POSITION / 2;
                  this["cat" + i + "_button"].label.height = this.NBRLINES_2;
                  break;
               case 3:
                  this["cat" + i + "_button"].label.y = 0;
                  this["cat" + i + "_button"].label.height = this.NBRLINES_3;
            }
         }
         categories = null;
      }
      
      protected function formatListItem(_row:ButtonListApplication, isSelect:Boolean = false) : void
      {
         if(_row == null)
         {
            return;
         }
         Text.align(_row.label);
         Text.align(_row.select);
         if(LocaleArchive.getInstance().isMirrored())
         {
            _row.label.x = isSelect ? 115 : 55;
            _row.label.width = isSelect ? 285 : 340;
            _row.x = 0;
            _row.select.x = 4;
            _row.appMask.x = 399;
            _row.window.x = 399;
         }
         else
         {
            _row.label.x = 55;
            _row.label.width = isSelect ? 285 : 340;
            _row.x = 85;
            _row.select.x = 340;
            _row.appMask.x = 3;
            _row.window.x = 3;
         }
      }
   }
}

