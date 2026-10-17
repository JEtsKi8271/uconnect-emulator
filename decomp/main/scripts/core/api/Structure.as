package core.api
{
   import com.nfuzion.framework.global.Framework;
   import core.events.ExtensionEvent;
   import core.events.StructureEvent;
   import flash.events.EventDispatcher;
   
   public class Structure extends EventDispatcher implements IStructure
   {
      
      private static const DOMAIN:String = "MIDDLE";
      
      private var mMaxHistoryLength:int = 20;
      
      private var mBusy:Boolean = false;
      
      private var mJustCalled:String = "";
      
      private var mCurrentBranch:String = "";
      
      private var mCurrentExtension:int = -1;
      
      private var mCurrentVars:Object;
      
      private var mHistory:Vector.<Object> = new Vector.<Object>();
      
      public function Structure()
      {
         super();
      }
      
      public function set currentBranch(_branch:String) : void
      {
         this.mCurrentBranch = _branch;
      }
      
      public function get currentBranch() : String
      {
         return this.mCurrentBranch;
      }
      
      public function get currentExtension() : int
      {
         return this.mCurrentExtension;
      }
      
      public function get variables() : Object
      {
         return this.mHistory[this.mHistory.length - 1].variables;
      }
      
      public function set variables(_variables:Object) : void
      {
         this.mHistory[this.mHistory.length - 1].variables = _variables;
      }
      
      public function historyIndexOf(_branch:String) : int
      {
         var len:int = int(this.mHistory.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this.mHistory[len - 1 - i].branch == _branch)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function goto(_branch:String, _vars:Object = null, _addToHistory:Boolean = true) : void
      {
         if(_branch == "")
         {
            trace("<Structure> goto() : This branch \'" + _branch + "\' does not exist...");
            return;
         }
         if(_vars != null && _vars.hasOwnProperty("ext"))
         {
            this.mCurrentExtension = _vars.ext;
            dispatchEvent(new ExtensionEvent(ExtensionEvent.EXTENSION,_vars));
         }
         else
         {
            this.mCurrentExtension = -1;
         }
         if(_addToHistory)
         {
            this.updateHistory({
               "branch":_branch,
               "variables":_vars,
               "exitPoint":false
            });
         }
         if(!Framework.mapping.isNavDomain(_branch))
         {
            dispatchEvent(new StructureEvent(StructureEvent.LEAVING_NAV,""));
         }
         if(!this.mBusy && _branch != this.mCurrentBranch)
         {
            this.mCurrentBranch = _branch;
            this.mCurrentVars = _vars;
            Framework.screens.goto(_branch,DOMAIN,_vars);
         }
         if(_branch == this.mCurrentBranch)
         {
            this.dispatchEvent(new StructureEvent(StructureEvent.REFRESH_STRUCTURE,_branch,_vars));
         }
      }
      
      public function getAddress(gotoAddress:String) : String
      {
         return Framework.screens.getAddress(gotoAddress);
      }
      
      public function back() : void
      {
         var i:* = 0;
         var backObject:Object = null;
         if(this.mHistory.length > 1)
         {
            if(!this.mHistory[this.mHistory.length - 1].exitPoint)
            {
               for(i = int(this.mHistory.length - 1); i > 0; i--)
               {
                  if(this.mHistory[i].branch != this.currentBranch)
                  {
                     break;
                  }
                  this.mHistory.splice(i,1);
               }
               backObject = this.mHistory[this.mHistory.length - 1];
               if(backObject.variables == null)
               {
                  backObject.variables = new Object();
               }
               backObject.variables._back = true;
               if(Framework.mapping.isNavDomain(backObject.branch))
               {
                  dispatchEvent(new StructureEvent(StructureEvent.ACTIVATE_NAV,""));
                  return;
               }
               this.goto(backObject.branch,backObject.variables,false);
            }
         }
         else
         {
            trace("<Structure> back() : Stack History length not sufficient!");
         }
      }
      
      public function gotolastScreen() : void
      {
         var backObject:Object = null;
         if(this.mHistory.length > 1)
         {
            this.mHistory.pop();
            backObject = this.mHistory[this.mHistory.length - 1];
            if(backObject.variables == null)
            {
               backObject.variables = new Object();
            }
            backObject.variables._back = true;
            if(Framework.mapping.isNavDomain(backObject.branch))
            {
               dispatchEvent(new StructureEvent(StructureEvent.ACTIVATE_NAV,""));
               return;
            }
            this.goto(backObject.branch,backObject.variables,false);
         }
      }
      
      public function setExit() : void
      {
         if(this.mHistory.length > 0)
         {
            this.mHistory[this.mHistory.length - 1].exitPoint = true;
         }
      }
      
      public function captureExit() : void
      {
         if(this.mHistory.length > 1)
         {
            this.mHistory[this.mHistory.length - 2].exitPoint = true;
         }
      }
      
      public function exit() : void
      {
         var historyObj:Object = null;
         if(this.mHistory.length > 1)
         {
            if(this.mHistory[this.mHistory.length - 1].exitPoint != true)
            {
               while(this.mHistory.length > 1)
               {
                  historyObj = this.mHistory.pop();
                  if(Framework.mapping.isNavDomain(historyObj.branch))
                  {
                     dispatchEvent(new StructureEvent(StructureEvent.ACTIVATE_NAV,""));
                     return;
                  }
                  if(historyObj.exitPoint == true)
                  {
                     this.goto(historyObj.branch,historyObj.variables);
                     return;
                  }
               }
               if(Framework.mapping.isNavDomain(this.mHistory[0].branch))
               {
                  dispatchEvent(new StructureEvent(StructureEvent.ACTIVATE_NAV,""));
               }
               else
               {
                  this.goto(this.mHistory[0].branch,this.mHistory[0].variables);
               }
            }
         }
      }
      
      public function getStackIndex(_branch:String) : int
      {
         var _index:int = 0;
         var i:* = 0;
         if(this.mHistory.length > 1)
         {
            _index = 0;
            for(i = int(this.mHistory.length - 1); i > 1; i--)
            {
               if(this.mHistory[i].branch == _branch)
               {
                  return _index;
               }
               if(this.mHistory[i].exitPoint)
               {
                  return -1;
               }
               _index++;
            }
         }
         return -1;
      }
      
      public function removeFromStack(_branch:String) : void
      {
         var i:* = 0;
         if(this.mHistory.length > 1)
         {
            for(i = int(this.mHistory.length - 1); i > 0; i--)
            {
               if(this.mHistory[i].branch == _branch)
               {
                  this.mHistory.splice(i,1);
               }
            }
         }
      }
      
      public function findAndReplace(_branch:String, _newBranch:String, _vars:Object = null, _exitPoint:Boolean = false) : void
      {
         var i:* = 0;
         if(this.mHistory.length > 1)
         {
            for(i = int(this.mHistory.length - 1); i >= 0; i--)
            {
               if(this.mHistory[i].branch == _branch)
               {
                  this.mHistory.splice(i,1,{
                     "branch":_newBranch,
                     "variables":_vars,
                     "exitPoint":_exitPoint
                  });
                  return;
               }
            }
         }
      }
      
      public function returnExitBranch() : String
      {
         var i:* = 0;
         if(this.mHistory.length > 0)
         {
            for(i = int(this.mHistory.length - 1); i >= 0; i--)
            {
               if(this.mHistory[i].exitPoint == true || i == 0)
               {
                  return this.mHistory[i].branch;
               }
            }
         }
         return "";
      }
      
      public function returnTo(_branch:String) : void
      {
         var i:* = 0;
         var _returnTo:Object = null;
         if(this.mHistory.length > 0)
         {
            for(i = int(this.mHistory.length - 1); i >= 0; i--)
            {
               if(this.mHistory[i].branch == _branch)
               {
                  if(Framework.mapping.isNavDomain(_branch))
                  {
                     dispatchEvent(new StructureEvent(StructureEvent.ACTIVATE_NAV,""));
                     return;
                  }
                  _returnTo = this.mHistory.splice(i,this.mHistory.length - i)[0];
                  this.goto(_returnTo.branch,_returnTo.variables);
                  return;
               }
            }
         }
      }
      
      public function updateHistory(_screen:Object) : void
      {
         if(this.mCurrentBranch != _screen.branch)
         {
            this.mHistory.push(_screen);
         }
         else if(_screen.variables != null && Boolean(_screen.variables.hasOwnProperty("ext")))
         {
            this.mHistory.push(_screen);
         }
         if(this.mHistory.length > this.mMaxHistoryLength)
         {
            this.mHistory.shift();
         }
      }
      
      public function taskComplete(_address:String) : void
      {
         this.mBusy = false;
      }
   }
}

