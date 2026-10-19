package com.harman.ui
{
   import com.nfuzion.framework.global.Framework;
   import events.SoundEvent;
   import events.WidgetEvent;
   
   public class ButtonBarGrey extends ButtonBarRegular
   {
      
      public function ButtonBarGrey()
      {
         super();
      }
      
      override protected function click() : void
      {
         if(!mFiring)
         {
            Framework.messenger.dispatchEvent(new SoundEvent(mEnabled ? SoundEvent.CLICK : SoundEvent.REJECT));
         }
         this.dispatchEvent(new WidgetEvent(WidgetEvent.CLICK,this));
         mFiring = true;
      }
   }
}

