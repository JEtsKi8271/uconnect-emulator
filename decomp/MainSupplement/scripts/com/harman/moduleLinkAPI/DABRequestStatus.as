package com.harman.moduleLinkAPI
{
   public class DABRequestStatus
   {
      
      public var code:int;
      
      public var description:String = "";
      
      public function DABRequestStatus(codein:int = 0, descin:String = "")
      {
         super();
         this.code = codein;
         this.description = descin;
      }
   }
}

