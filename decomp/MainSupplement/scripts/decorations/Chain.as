package decorations
{
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public dynamic class Chain extends Group
   {
      
      private var mChain:MovieClip;
      
      private var mItems:Vector.<MovieClip>;
      
      private var mLinks:Vector.<*>;
      
      private var mItemUpdater:Function = null;
      
      public function Chain(chain:MovieClip)
      {
         var items:Vector.<MovieClip>;
         var i:int = 0;
         var child:MovieClip = null;
         var parsedChildName:Array = null;
         this.mItems = new Vector.<MovieClip>();
         this.mLinks = new Vector.<*>();
         super(chain);
         this.mChain = chain;
         for(items = new Vector.<MovieClip>(); i < this.mChain.numChildren; )
         {
            child = this.mChain.getChildAt(i) as MovieClip;
            if(child != null && child.name != null)
            {
               parsedChildName = child.name.split("_");
               if(parsedChildName.length >= 2 && parsedChildName[0] == "item")
               {
                  child.item = int(parsedChildName[1]);
                  items.push(child);
               }
            }
            i++;
         }
         this.mItems = items.sort(function(x:MovieClip, y:MovieClip):int
         {
            return x.item - y.item;
         });
         for(i = 0; i < this.mItems.length; i++)
         {
            this.mItems[i].item = i;
            this.mItems[i].addEventListener(MouseEvent.CLICK,this.itemClicked);
         }
         this.update();
      }
      
      public function getItemCount() : int
      {
         return this.mItems.length;
      }
      
      public function getLinkCount() : int
      {
         return this.mLinks.length;
      }
      
      public function setLinks(links:*) : void
      {
         var link:* = undefined;
         if(links is Array)
         {
            this.mLinks = new Vector.<*>();
            for each(link in links)
            {
               this.mLinks.push(link);
            }
         }
         else
         {
            this.mLinks = links;
         }
         this.update();
      }
      
      override public function update() : void
      {
         for(var itemPosition:int = 0; itemPosition < this.mItems.length; itemPosition++)
         {
            if(this.mItemUpdater != null && this.mLinks != null && itemPosition < this.mLinks.length && Boolean(this.mLinks[itemPosition]))
            {
               this.mItemUpdater(this.mItems[itemPosition],this.mLinks[itemPosition]);
               this.mItems[itemPosition].visible = true;
            }
            else
            {
               this.mItems[itemPosition].visible = false;
            }
         }
      }
      
      public function setItemUpdater(itemUpdater:Function) : void
      {
         this.mItemUpdater = itemUpdater;
      }
      
      private function itemClicked(e:MouseEvent) : void
      {
         var itemIndex:int = int(e.currentTarget.item);
         if(itemIndex < this.mLinks.length)
         {
            this.mChain.dispatchEvent(new WidgetEvent(WidgetEvent.SELECT,{
               "targetName":this.mLinks[itemIndex],
               "visualIndex":itemIndex,
               "visual":this.mItems[itemIndex]
            },true));
         }
      }
   }
}

