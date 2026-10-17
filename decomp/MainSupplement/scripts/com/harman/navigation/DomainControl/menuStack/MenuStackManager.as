package com.harman.navigation.DomainControl.menuStack
{
   import com.nfuzion.framework.global.Framework;
   
   public class MenuStackManager
   {
      
      private var mStackArray:Array = new Array();
      
      public function MenuStackManager()
      {
         super();
      }
      
      public function createStack(name:String, baseMenuId:int) : void
      {
         var newStack:MenuStack = new MenuStack(name,baseMenuId);
         this.mStackArray.push(newStack);
      }
      
      public function getStack(index:int) : MenuStack
      {
         if(this.mStackArray.length <= index)
         {
            Framework.Trace("MenuStackManager.getStack: Access violation WARNING! " + this.mStackArray.length);
         }
         return this.mStackArray[index];
      }
   }
}

