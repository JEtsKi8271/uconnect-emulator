package core.theme
{
   import core.api.IThemeEngine;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.System;
   import flash.text.Font;
   import skin.Skin;
   import skin.Style;
   import skin.StyleEvent;
   
   public class ThemeEngine extends EventDispatcher implements IThemeEngine
   {
      
      private static const DEFAULT_THEME:String = "Default/001_Uconnect.swf";
      
      private static const DEFAULT_FONT:String = "fontSwfs/HelveticaNeueLTStd-Roman.swf";
      
      private var mReady:Boolean = false;
      
      private var mBusy:Boolean = false;
      
      private var mSkin:String;
      
      private var mTheme:String;
      
      private var mThemeCached:String;
      
      private var mFont:String;
      
      private var mFontCached:String;
      
      private var mThemeLoader:Loader;
      
      private var mFontLoader:Loader;
      
      private var mThemeMovieClip:MovieClip;
      
      private var mFontMovieClip:MovieClip;
      
      public function ThemeEngine()
      {
         super();
      }
      
      public function init(_skin:String = "default", _theme:String = "Default/001_Uconnect.swf", _font:String = "fontSwfs/HelveticaNeueLTStd-Roman.swf") : void
      {
         trace("<ThemingEngine> Starting...");
         this.mSkin = "skins/" + _skin + "/themeSwfs/";
         this.mTheme = _theme;
         this.mFont = _font;
         Skin.style = new Style();
         this.loadTheme(_theme);
      }
      
      public function set ready(_ready:Boolean) : void
      {
         trace("<ThemingEngine> Ready!");
         this.mBusy = false;
         this.mReady = _ready;
         if(this.mReady)
         {
            Skin.style.dispatchEvent(new StyleEvent(StyleEvent.THEME_CHANGE,true));
            dispatchEvent(new Event(Event.COMPLETE));
            System.gc();
         }
      }
      
      public function get ready() : Boolean
      {
         return this.mReady;
      }
      
      public function get theme() : String
      {
         return this.mTheme;
      }
      
      public function set theme(_path:String) : void
      {
         this.loadTheme(_path);
      }
      
      public function get font() : String
      {
         return this.mFont;
      }
      
      public function set font(_path:String) : void
      {
         this.loadFont(_path);
      }
      
      public function loadTheme(_path:String) : void
      {
         this.mTheme = _path;
         if(this.mBusy)
         {
            trace("<ThemingEngine> I\'m Busy Leave me Alone! " + this.mThemeCached + " Currently loading...");
            return;
         }
         if(this.mThemeCached != this.mTheme)
         {
            this.mBusy = true;
            this.mThemeCached = this.mTheme;
            if(this.mThemeLoader != null)
            {
               this.mThemeLoader.unloadAndStop(true);
               this.mThemeLoader = null;
            }
            trace("<ThemingEngine> Loading Theme..." + this.mTheme);
            this.mThemeLoader = new Loader();
            this.mThemeLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onThemeSWFLoaded,false,0,true);
            this.mThemeLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadThemeSWFError,false,0,true);
            this.mThemeLoader.load(new URLRequest(this.mSkin + this.mTheme));
         }
         else
         {
            this.ready = true;
         }
      }
      
      public function loadFont(_path:String) : void
      {
         this.mFont = _path;
         if(this.mFontCached != this.mFont)
         {
            this.mFontCached = this.mFont;
            if(this.mFontLoader != null)
            {
               this.mFontLoader.unloadAndStop(true);
               this.mFontLoader = null;
            }
            trace("<ThemingEngine> Loading Font(s)... " + this.mFont);
            this.mFontLoader = new Loader();
            this.mFontLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onFontSWFLoaded,false,0,true);
            this.mFontLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadFontSWFError,false,0,true);
            this.mFontLoader.load(new URLRequest(this.mSkin + this.mFont));
         }
         else
         {
            trace("<ThemingEngine> Fonts already loaded! " + _path);
            this.ready = true;
         }
      }
      
      private function onThemeSWFLoaded(e:Event) : void
      {
         trace("<ThemingEngine> Theme Loaded!");
         this.mThemeMovieClip = this.mThemeLoader.content as MovieClip;
         Skin.style.getValuesFromThemeSWF(this.mThemeMovieClip);
         this.loadFont(this.mFont);
         this.mThemeLoader.unloadAndStop();
         this.mThemeLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onThemeSWFLoaded);
         this.mThemeLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadThemeSWFError);
         this.mThemeLoader = null;
      }
      
      private function onFontSWFLoaded(e:Event) : void
      {
         var f:Font = null;
         trace("<ThemingEngine> Font(s) Loaded!");
         this.mFontMovieClip = this.mFontLoader.content as MovieClip;
         for each(f in Font.enumerateFonts())
         {
            if(f.fontType != "embedded")
            {
               continue;
            }
            switch(f.fontName)
            {
               case Skin.style.currentTheme.FONT_PRIMARY:
                  Font.registerFont(this.mFontMovieClip.PrimaryFont);
                  trace("<ThemingEngine> Primary Font Registered!");
                  break;
               case Skin.style.currentTheme.FONT_SECONDARY:
                  Font.registerFont(this.mFontMovieClip.SecondaryFont);
                  trace("<ThemingEngine> Secondary Font Registered!");
                  break;
               case Skin.style.currentTheme.FONT_TERTIARY:
                  Font.registerFont(this.mFontMovieClip.TertiaryFont);
                  trace("<ThemingEngine> Tertiary Font Registered!");
            }
         }
         this.mFontLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onFontSWFLoaded);
         this.mFontLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadFontSWFError);
         this.ready = true;
      }
      
      private function onLoadThemeSWFError(e:Event) : void
      {
         trace("<ThemingEngine> Error : Theme Swf not found!");
         this.loadTheme(DEFAULT_THEME);
      }
      
      private function onLoadFontSWFError(e:Event) : void
      {
         trace("<ThemingEngine> Error : Font Swf not found!");
         this.loadFont(DEFAULT_FONT);
      }
   }
}

