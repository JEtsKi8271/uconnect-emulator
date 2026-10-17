package com.harman.navigation.overTheAirUpdate
{
   import com.harman.navigation.utils.EisHelper;
   
   public class UpdatePackage
   {
      
      private var mDetails:String = "";
      
      private var mSelected:Boolean = false;
      
      private var mDownloadHandle:int = -1;
      
      private var mDownloadStatus:int = -1;
      
      private var mDownloadProgress:int = -1;
      
      private var mImagePath:String = "";
      
      public function UpdatePackage(details:String)
      {
         super();
         this.mDetails = details;
      }
      
      public function setDetails(details:String) : void
      {
         this.mDetails = details;
      }
      
      public function get details() : String
      {
         return this.mDetails;
      }
      
      public function get url() : String
      {
         return EisHelper.getValueOfType(this.mDetails,"<URL>");
      }
      
      public function get title() : String
      {
         return EisHelper.getValueOfType(this.mDetails,"<NAME>") + " (" + EisHelper.getValueOfType(this.mDetails,"<TYPE>") + ")" + ", " + EisHelper.getValueOfType(this.mDetails,"<VER>") + ", " + EisHelper.getValueOfType(this.mDetails,"<DATE>") + ", " + this.formatFileSize(int(EisHelper.getValueOfType(this.mDetails,"<SIZE>")));
      }
      
      public function selectForDownload(select:Boolean) : void
      {
         this.mSelected = select;
      }
      
      public function selectForDownloadToggle() : void
      {
         this.mSelected = !this.mSelected;
      }
      
      public function get selectedForDownload() : Boolean
      {
         return this.mSelected;
      }
      
      public function setDownloadHandle(handle:int) : void
      {
         this.mDownloadHandle = handle;
         this.mDownloadProgress = 0;
      }
      
      public function get downloadHandle() : int
      {
         return this.mDownloadHandle;
      }
      
      public function setDownloadStatus(status:int) : void
      {
         this.mDownloadStatus = status;
      }
      
      public function get downloadStatus() : int
      {
         return this.mDownloadStatus;
      }
      
      public function setDownloadProgress(progress:int) : void
      {
         this.mDownloadProgress = progress;
      }
      
      public function get downloadProgress() : int
      {
         return this.mDownloadProgress;
      }
      
      public function setImagePath(path:String) : void
      {
         this.mImagePath = path;
      }
      
      public function get imagePath() : String
      {
         return this.mImagePath;
      }
      
      private function formatFileSize(size:int) : String
      {
         if(size < 1024)
         {
            return Number(Number(size) / 1024).toFixed(1) + "MB";
         }
         return Number(Number(size) / (1024 * 1024)).toFixed(1) + "GB";
      }
   }
}

