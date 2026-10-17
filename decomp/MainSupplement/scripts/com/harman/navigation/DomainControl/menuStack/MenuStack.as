package com.harman.navigation.DomainControl.menuStack
{
   import com.nfuzion.framework.global.Framework;
   
   public class MenuStack
   {
      
      private var mName:String = "";
      
      private var mBaseMenu:int = 0;
      
      private var mStack:Array = new Array();
      
      private var mMenus:NavMenus;
      
      public function MenuStack(name:String, baseMenuId:int)
      {
         super();
         this.mName = name;
         this.mBaseMenu = baseMenuId;
         this.mMenus = new NavMenus(this);
      }
      
      public function deactivateCurrentMenu() : void
      {
         this.mMenus.deactivateMenu(this.mStack[this.mStack.length - 1],false);
      }
      
      public function reactivateCurrentMenu() : void
      {
         this.mMenus.activateMenu(this.mStack[this.mStack.length - 1]);
      }
      
      public function addMenu(index:int) : void
      {
         this.mMenus.deactivateMenu(this.mStack[this.mStack.length - 1],false);
         this.mStack.push(index);
         this.mMenus.activateMenu(this.mStack[this.mStack.length - 1]);
      }
      
      public function setBaseMenu(index:int) : void
      {
         this.mStack.push(index);
      }
      
      public function removeLastMenu() : Boolean
      {
         if(this.mStack.length > 1)
         {
            if(this.mMenus.deactivateMenu(this.mStack[this.mStack.length - 1],true) == true)
            {
               Framework.Trace("MenuStack.removeLastMenu:" + int(this.mStack[this.mStack.length - 1]) + " length:" + this.mStack.length);
               this.mStack.splice(this.mStack.length - 1,1);
            }
         }
         if(this.mStack[this.mStack.length - 1] == NavMenus.MENU_STACK_SWITCH_MARKER)
         {
            this.mStack.splice(this.mStack.length - 1);
            return false;
         }
         if(this.mStack.length > 0)
         {
            this.mMenus.activateMenu(this.mStack[this.mStack.length - 1]);
         }
         return true;
      }
      
      public function removeLastMenuNoDeactivate() : void
      {
         if(this.mStack.length > 0)
         {
            Framework.Trace("removeLastMenuNoDeactivate:" + int(this.mStack[this.mStack.length - 1]) + " length:" + this.mStack.length);
            this.mStack.splice(this.mStack.length - 1,1);
         }
         if(this.mStack.length > 0)
         {
            this.mMenus.activateMenu(this.mStack[this.mStack.length - 1]);
         }
      }
      
      public function removeLastMenuNoAction() : void
      {
         if(this.mStack.length > 0)
         {
            Framework.Trace("removeLastMenuNoAction:" + int(this.mStack[this.mStack.length - 1]) + " length:" + this.mStack.length);
            this.mStack.splice(this.mStack.length - 1,1);
         }
      }
      
      public function deactivateLastMenuFlow() : void
      {
         Framework.Trace("deactivateLastMenuFlow");
         switch(this.mStack[this.mStack.length - 1])
         {
            case NavMenus.MENU_FLOW_INPUT_LOCATION:
               this.mMenus.activateLocationIputFlow(false);
               break;
            case NavMenus.MENU_FLOW_INPUT_POI:
               this.mMenus.activatePoiIputFlow(false);
               break;
            default:
               Framework.Trace("MenuStack.deactivateLastMenuFlow: No flow on last position: " + this.mStack[this.mStack.length - 1]);
         }
         this.mStack.splice(this.mStack.length - 1,1);
         this.mMenus.activateMenu(this.mStack[this.mStack.length - 1]);
      }
      
      public function goBackToMenu(menu:int) : void
      {
         for(var i:* = int(this.mStack.length - 1); i >= 0; i--)
         {
            if(int(this.mStack[i]) == menu)
            {
               this.mMenus.activateMenu(this.mStack[this.mStack.length - 1]);
               return;
            }
            this.mStack.splice(i,1);
         }
         Framework.Trace("MenuStack.goBackToMenu( " + menu + " ) Show base menu!");
      }
      
      public function clearAll() : void
      {
         this.deactivateCurrentMenu();
         this.mStack = new Array();
      }
      
      public function get currentMenu() : int
      {
         return this.mStack[this.mStack.length - 1];
      }
      
      public function get name() : String
      {
         return this.mName;
      }
      
      public function setDomainSwitchScreenName(returnScreen:Object) : void
      {
         this.mMenus.setDomainSwitchScreenName(returnScreen);
      }
      
      public function setBackFlag() : void
      {
         this.mMenus.setBackFlag();
      }
   }
}

