package com.harman.moduleLinkAPI
{
   public class DABTunerControlVersions
   {
      
      public var majorVersion:int;
      
      public var minorVersion:int;
      
      public var patchVersion:int;
      
      public function DABTunerControlVersions(tunerControl:Object = null)
      {
         super();
         if(tunerControl != null)
         {
            this.majorVersion = tunerControl.majorVersion;
            this.minorVersion = tunerControl.minorVersion;
            this.patchVersion = tunerControl.patchVersion;
         }
      }
   }
}

