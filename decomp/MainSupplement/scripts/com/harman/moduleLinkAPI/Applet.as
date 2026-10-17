package com.harman.moduleLinkAPI
{
   public class Applet
   {
      
      public var id:int = 0;
      
      public var cat:int = -2;
      
      public var appId:String = "";
      
      public var label:String = "";
      
      public var shortNameString:String = "";
      
      public var mediumNameString:String = "";
      
      public var fullNameString:String = "";
      
      public var select:String = "";
      
      public var smicon:String = "";
      
      public var lgicon:String = "";
      
      public var exlgicon:String = "";
      
      public var version:String = "";
      
      public var status:String = "";
      
      public var type:String = "";
      
      public var daemon:Boolean = false;
      
      public var hasGUI:Boolean = false;
      
      public var favorite:Boolean = false;
      
      public var embedded:Boolean = false;
      
      public var extracted:Boolean = false;
      
      public var statusbar:Boolean = false;
      
      public function Applet(name:String)
      {
         super();
         this.label = name;
      }
   }
}

