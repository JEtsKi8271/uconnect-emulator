package core.utils
{
   import core.enums.AppIcon;
   import core.enums.BitmapType;
   import core.events.AppEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class LoadBMP extends MovieClip
   {
      
      private var mCount:int;
      
      private var mBMPLoader:CustomURLLoader = null;
      
      private var mPNGLoader:CustomLoader = null;
      
      private var mHistory:Array = new Array();
      
      private var mScalable:Boolean = false;
      
      private var mWidth:Number = 35;
      
      private var mHeight:Number = 35;
      
      public function LoadBMP()
      {
         super();
      }
      
      public function addImage(request:String, window:MovieClip, cachePath:Boolean = true) : void
      {
         var i:int = 0;
         var data:BitmapData = null;
         var png:Bitmap = null;
         if(cachePath)
         {
            i = -1;
            while(++i < this.mHistory.length)
            {
               if(request == this.mHistory[i].path)
               {
                  if(this.mHistory[i].ok)
                  {
                     data = this.mHistory[i].bmp.bitmapData;
                     png = new Bitmap(data.clone());
                     this.removeImage(window);
                     png.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
                     window.addChild(png);
                     return;
                  }
               }
            }
         }
         var icon:AppIcon = new AppIcon();
         icon.path = request;
         icon.type = request.substring(request.length - 3);
         icon.window = window;
         this.mHistory.push(icon);
         switch(icon.type.toLowerCase())
         {
            case BitmapType.BMP:
               this.mBMPLoader = new CustomURLLoader();
               this.mBMPLoader.dataFormat = URLLoaderDataFormat.BINARY;
               this.mBMPLoader.id = this.mCount;
               this.mBMPLoader.addEventListener(Event.COMPLETE,this.onBitmapLoaded,false,0,true);
               this.mBMPLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onBitmapErrorHandler,false,0,true);
               this.mBMPLoader.load(new URLRequest(request));
               break;
            case BitmapType.JPG:
            case BitmapType.PNG:
               this.mPNGLoader = new CustomLoader();
               this.mPNGLoader.id = this.mCount;
               this.mPNGLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onBitmapLoaded,false,0,true);
               this.mPNGLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onBitmapErrorHandler,false,0,true);
               this.mPNGLoader.load(new URLRequest(request));
               break;
            default:
               trace("<HMICore> [ LoadBMP ] Do Not recognize bitmap type : " + icon.type);
               this.removeImage(window);
               return;
         }
         ++this.mCount;
      }
      
      public function removeImage(window:MovieClip, clearAll:Boolean = true) : void
      {
         var count:int = clearAll ? 0 : 1;
         while(window.numChildren > count)
         {
            window.removeChildAt(0);
         }
      }
      
      private function onBitmapLoaded(e:Event) : void
      {
         var icon:AppIcon = null;
         var bd:BitmapData = null;
         var mDecoder:BMPDecoder = null;
         e.currentTarget.removeEventListener(Event.COMPLETE,this.onBitmapLoaded);
         e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,this.onBitmapErrorHandler);
         if(e.currentTarget is CustomURLLoader)
         {
            icon = this.mHistory[e.currentTarget.id];
            icon.ok = true;
            mDecoder = new BMPDecoder();
            bd = mDecoder.decode(e.currentTarget.data);
            icon.bmp = new Bitmap(bd);
            mDecoder = null;
         }
         else
         {
            icon = this.mHistory[e.currentTarget.loader.id];
            icon.ok = true;
            bd = e.currentTarget.content.bitmapData;
            icon.bmp = new Bitmap(e.currentTarget.content.bitmapData);
         }
         icon.bmp.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
         this.removeImage(icon.window);
         icon.window.addChild(icon.bmp);
      }
      
      private function onBitmapErrorHandler(e:IOErrorEvent) : void
      {
         var icon:AppIcon = null;
         trace("<HMICore> [ IO ERROR LoadBMP ] invalid path " + e.toString());
         e.currentTarget.removeEventListener(Event.COMPLETE,this.onBitmapLoaded);
         e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,this.onBitmapErrorHandler);
         if(e.currentTarget is CustomURLLoader)
         {
            this.removeImage(this.mHistory[e.currentTarget.id].window);
         }
         else
         {
            this.removeImage(this.mHistory[e.currentTarget.loader.id].window);
         }
      }
      
      private function onAddedToStage(e:Event) : void
      {
         var _hDiff:Number = NaN;
         var _wDiff:Number = NaN;
         var _scale:Number = NaN;
         var _png:Bitmap = e.currentTarget as Bitmap;
         if(this.mScalable)
         {
            _hDiff = _png.height - this.mHeight;
            _wDiff = _png.width - this.mWidth;
            _scale = 0;
            if(!(_wDiff <= 0 && _hDiff <= 0))
            {
               if(_wDiff > _hDiff)
               {
                  _png.smoothing = true;
                  _scale = this.mWidth / _png.width;
                  _png.scaleY = _scale;
                  _png.scaleX = _scale;
               }
               else
               {
                  _png.smoothing = true;
                  _scale = this.mHeight / _png.height;
                  _png.scaleX = _scale;
                  _png.scaleY = _scale;
               }
            }
         }
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.dispatchEvent(new AppEvent(AppEvent.ICON_ADDED));
      }
      
      public function set scalable(_scale:Boolean) : void
      {
         this.mScalable = _scale;
      }
      
      public function clearCache(clearAll:Boolean = true) : void
      {
         this.mCount = clearAll ? 0 : 1;
         while(this.mHistory.length > this.mCount)
         {
            this.removeImage(this.mHistory[0].window,clearAll);
            if(this.mHistory[0].bmp != null)
            {
               this.mHistory[0].bmp.bitmapData.dispose();
               this.mHistory[0].bmp = null;
            }
            this.mHistory.shift();
         }
      }
      
      public function flushButIgnoreThesePaths(_ignore:Array) : void
      {
         for(var i:int = 0; i < this.mHistory.length; i++)
         {
            if(this.check(_ignore,this.mHistory[i].path))
            {
               if(this.mHistory[i].bmp != null)
               {
                  this.mHistory[i].ok = false;
                  this.mHistory[i].bmp.bitmapData.dispose();
                  this.mHistory[i].bmp = null;
               }
            }
         }
      }
      
      private function check(_ignore:Array, _path:String) : Boolean
      {
         for(var i:int = 0; i < _ignore.length; i++)
         {
            if(_ignore[i] == _path)
            {
               return true;
            }
         }
         return false;
      }
      
      public function flush() : void
      {
         while(this.mHistory.length > 0)
         {
            this.removeImage(this.mHistory[0].window);
            if(this.mHistory[0].bmp != null)
            {
               this.mHistory[0].bmp.bitmapData.dispose();
               this.mHistory[0].bmp = null;
            }
            this.mHistory.shift();
         }
         this.mHistory = null;
      }
      
      public function set imageWidth(_width:Number) : void
      {
         this.mWidth = _width;
      }
      
      public function set imageHeight(_height:Number) : void
      {
         this.mHeight = _height;
      }
   }
}

