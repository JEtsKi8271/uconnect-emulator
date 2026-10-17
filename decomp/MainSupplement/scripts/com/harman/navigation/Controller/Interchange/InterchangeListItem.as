package com.harman.navigation.Controller.Interchange
{
   public class InterchangeListItem
   {
      
      private var mIsEnabled:Boolean = true;
      
      private var mListEntryType:int = Interchange.LIST_ENTRY_TYPE_UNDEFINED;
      
      private var mTitle:String = "";
      
      private var mSelectRequest:String = "";
      
      public function InterchangeListItem()
      {
         super();
      }
      
      public function get enabled() : Boolean
      {
         return this.mIsEnabled;
      }
      
      public function set enabled(enabled:Boolean) : void
      {
         this.mIsEnabled = enabled;
      }
      
      public function get listEntryType() : int
      {
         return this.mListEntryType;
      }
      
      public function set listEntryType(listEntryType:int) : void
      {
         this.mListEntryType = listEntryType;
      }
      
      public function get title() : String
      {
         return this.mTitle;
      }
      
      public function set title(title:String) : void
      {
         this.mTitle = title;
      }
      
      public function get request() : String
      {
         return this.mSelectRequest;
      }
      
      public function set request(request:String) : void
      {
         this.mSelectRequest = request;
      }
   }
}

