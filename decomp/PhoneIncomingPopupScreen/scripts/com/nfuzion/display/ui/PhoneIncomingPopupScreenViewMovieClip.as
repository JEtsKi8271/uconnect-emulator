package com.nfuzion.display.ui
{
   public dynamic class PhoneIncomingPopupScreenViewMovieClip extends BaseMovieClip
   {
      
      public var btnAnswer_button:CallButtonMovieClip;
      
      public var btnIgnore_button:CallIgnoreButtonMovieClip;
      
      public var btnTransfer_button:ButtonMovieClip;
      
      public var displayPrimaryPhone:DisplayPhonePrimaryMovieClip;
      
      public var TransferButtonLabelMultiLine_Y:int = 2;
      
      public var TransferButtonLabelSingleLine_Y:int = 14;
      
      public var TransferButtonLabelHeight:int = 65;
      
      public function PhoneIncomingPopupScreenViewMovieClip()
      {
         super();
         this.btnTransfer_button.value_label.height = this.TransferButtonLabelHeight;
      }
      
      public function updateTransferButtonLabel() : void
      {
         if(1 == this.btnTransfer_button.value_label.numLines)
         {
            this.btnTransfer_button.value_label.y = this.TransferButtonLabelSingleLine_Y;
         }
         else
         {
            this.btnTransfer_button.value_label.y = this.TransferButtonLabelMultiLine_Y;
         }
      }
   }
}

