package core.api
{
   import com.nfuzion.framework.global.Framework;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.FocusStack;
   import core.enums.FocusType;
   import core.enums.Layers;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import skin.Skin;
   import skin.StyleEvent;
   
   public class FocusManager extends EventDispatcher implements IFocusManager
   {
      
      private const LOWEST_LAYER:String = "TASKBAR";
      
      private const HIGHEST_LAYER:String = "POPUPS";
      
      private var LAYERS:Dictionary = new Dictionary();
      
      private var mEnabled:Boolean = false;
      
      private var mCurrentFocus:FocusObject = new FocusObject();
      
      private var mButtonDown:MovieClip = null;
      
      private var mBorderObject:MovieClip = null;
      
      private var mCursorTimeout:Timer = new Timer(5000,1);
      
      private var mBorderFilter:GlowFilter = new GlowFilter(3394815,1,6,6,3,1);
      
      public function FocusManager()
      {
         super();
         this.LAYERS[Layers.POPUPS] = new FocusStack();
         this.LAYERS[Layers.MIDDLE] = new FocusStack();
         this.LAYERS[Layers.TASKBAR] = new FocusStack();
         this.LAYERS[Layers.PROMPT] = new FocusStack();
         this.LAYERS[Layers.STATUS] = new FocusStack();
         this.LAYERS[Layers.BOTTOM] = new FocusStack();
      }
      
      public function init(_stage:Sprite) : void
      {
         Skin.style.addEventListener(StyleEvent.THEME_CHANGE,this.onThemeChange,false,0,true);
         _stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
         this.mCursorTimeout.addEventListener(TimerEvent.TIMER,this.onTimeout,false,0,true);
         this.onCursorColor();
      }
      
      private function onThemeChange(e:StyleEvent) : void
      {
         this.onCursorColor();
         this.createCursor();
      }
      
      private function onCursorColor() : void
      {
         this.mBorderFilter.color = Skin.style.currentTheme.cursorActive.color.hexValue;
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         this.setBorderObject(e.target);
         if(this.mCursorTimeout.running)
         {
            this.mCursorTimeout.reset();
            this.deleteCursor();
         }
      }
      
      private function onTimeout(e:TimerEvent) : void
      {
         this.deleteCursor();
      }
      
      public function get enabled() : Boolean
      {
         return this.mEnabled;
      }
      
      public function set enabled(_enabled:Boolean) : void
      {
         this.mEnabled = _enabled;
      }
      
      public function get cursorActive() : Boolean
      {
         return this.mCursorTimeout.running;
      }
      
      public function back() : Boolean
      {
         var _newFocus:FocusObject = null;
         var _oldLayer:String = null;
         if(this.mEnabled)
         {
            _newFocus = this.getPrevFocusObject();
            _oldLayer = this.mCurrentFocus.layer;
            if(_oldLayer != _newFocus.layer)
            {
               switch(_oldLayer)
               {
                  case Layers.POPUPS:
                     Framework.popupManager.close();
                     break;
                  case Layers.MIDDLE:
                     if(Framework.structure.returnExitBranch() == Framework.structure.currentBranch)
                     {
                        this.changeFocus(_newFocus);
                     }
                     else
                     {
                        if(Framework.mapping.isNavDomain(Framework.structure.currentBranch))
                        {
                           return false;
                        }
                        Framework.structure.back();
                     }
               }
            }
            else
            {
               this.changeFocus(_newFocus);
            }
         }
         return true;
      }
      
      public function exit() : Boolean
      {
         if(this.mCurrentFocus.layer != this.LOWEST_LAYER)
         {
            this.changeFocus(this.LAYERS[this.LOWEST_LAYER][FocusPriority.MINIMUM]);
            return true;
         }
         return false;
      }
      
      public function getBorderObject() : MovieClip
      {
         return this.mBorderObject;
      }
      
      public function setBorderObject(_object:Object) : void
      {
         var _cursorableObject:MovieClip = null;
         if(this.mCurrentFocus.objects == null || _object == null)
         {
            return;
         }
         this.mCursorTimeout.reset();
         this.deleteCursor();
         for(var j:int = 0; j < this.mCurrentFocus.objects.length; j++)
         {
            _cursorableObject = this.mCurrentFocus.getCursorableObject(1);
            if(_cursorableObject != null && _cursorableObject.name == _object.name)
            {
               this.mBorderObject = _cursorableObject;
               break;
            }
         }
      }
      
      public function getFocus() : FocusObject
      {
         return this.mCurrentFocus;
      }
      
      public function setFocus(_priority:String) : void
      {
         if(this.mCurrentFocus.layer != "" && this.LAYERS[this.mCurrentFocus.layer] != null && this.LAYERS[this.mCurrentFocus.layer][_priority] != null)
         {
            this.changeFocus(this.LAYERS[this.mCurrentFocus.layer][_priority]);
         }
      }
      
      public function deleteLayer(_layer:String) : void
      {
         if(this.mEnabled)
         {
            this.deleteCursor();
            FocusStack(this.LAYERS[_layer]).deleteFocusObjects();
            if(this.mCurrentFocus.layer == _layer)
            {
               this.mCurrentFocus = new FocusObject();
            }
            if(_layer != Layers.MIDDLE)
            {
               this.changeFocus(this.getHighestPriorityFocusObject(),false);
            }
         }
      }
      
      public function rotaryTriggered(_delta:int) : void
      {
         if(Framework.popupManager.active != -1)
         {
            Framework.popupManager.resetTimeout();
         }
         if(!this.mCursorTimeout.running)
         {
            _delta = 0;
         }
         this.mCursorTimeout.reset();
         this.mCursorTimeout.start();
         this.deleteCursor();
         this.mCurrentFocus.getCursorableObject(_delta);
         this.createCursor();
         if(this.mCurrentFocus.focusCallBack != null)
         {
            this.mCurrentFocus.focusCallBack({
               "type":FocusType.ROTARY,
               "value":_delta
            });
         }
      }
      
      public function selectTriggered(_released:Boolean) : void
      {
         if(Framework.popupManager.active != -1)
         {
            Framework.popupManager.resetTimeout();
         }
         this.mCursorTimeout.reset();
         this.mCursorTimeout.start();
         this.createCursor();
         if(!_released)
         {
            if(this.mCurrentFocus.getCursorableObject() != null)
            {
               this.mButtonDown = this.mCurrentFocus.getCursorableObject();
               this.mCurrentFocus.getCursorableObject().dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
            }
            if(this.mCurrentFocus.focusCallBack != null)
            {
               this.mCurrentFocus.focusCallBack({
                  "type":FocusType.ENTER_DOWN,
                  "value":this.mButtonDown
               });
            }
         }
         else
         {
            if(this.mButtonDown != null)
            {
               this.mButtonDown.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
               this.mButtonDown.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
            if(this.mCurrentFocus.focusCallBack != null && this.mButtonDown == this.mCurrentFocus.getCursorableObject())
            {
               this.mCurrentFocus.focusCallBack({
                  "type":FocusType.ENTER_RELEASE,
                  "value":this.mButtonDown
               });
            }
            this.mButtonDown = null;
         }
      }
      
      public function longPressTriggered() : void
      {
         if(this.mCurrentFocus.focusCallBack != null)
         {
            this.mCurrentFocus.focusCallBack({
               "type":FocusType.LONGPRESS,
               "value":this.mCurrentFocus.getCursorableObject()
            });
         }
      }
      
      public function addFocus(_focus:FocusObject) : void
      {
         if(this.validateLayer(_focus.layer))
         {
            if(this.validatePriority(_focus.priority))
            {
               this.LAYERS[_focus.layer][_focus.priority] = _focus;
               this.changeFocus(this.getHighestPriorityFocusObject(),false);
            }
         }
      }
      
      public function delFocus(_focus:FocusObject) : void
      {
         if(this.mCurrentFocus.layer == _focus.layer && this.mCurrentFocus.priority == _focus.priority)
         {
            this.deleteCursor();
            this.LAYERS[_focus.layer][_focus.priority] = null;
            this.changeFocus(this.getHighestPriorityFocusObject(),false);
         }
         else
         {
            this.LAYERS[_focus.layer][_focus.priority] = null;
         }
      }
      
      private function changeFocus(_focus:FocusObject, _timeout:Boolean = true) : void
      {
         this.deleteCursor();
         if(_focus != null && _focus != this.mCurrentFocus)
         {
            if(_timeout)
            {
               this.mCursorTimeout.reset();
               this.mCursorTimeout.start();
            }
            this.mCurrentFocus.index = 0;
            this.mCurrentFocus = _focus;
         }
         this.refresh();
      }
      
      private function getPrevFocusObject() : FocusObject
      {
         var _focus:FocusObject = null;
         var _layer:String = this.mCurrentFocus.layer;
         var _priority:String = this.mCurrentFocus.priority;
         if(!this.validateLayer(_layer))
         {
            _layer = this.HIGHEST_LAYER;
         }
         if(!this.validatePriority(_priority))
         {
            _priority = FocusPriority.MAXIMUM;
         }
         while(_focus == null)
         {
            if(_priority == FocusPriority.MINIMUM)
            {
               if(_layer == this.LOWEST_LAYER)
               {
                  return this.mCurrentFocus;
               }
               _layer = this.getPrevLayer(_layer);
               _priority = FocusPriority.MAXIMUM;
            }
            else
            {
               _priority = this.getPrevPriority(_priority);
            }
            _focus = this.LAYERS[_layer][_priority];
         }
         return _focus;
      }
      
      private function getHighestPriorityFocusObject() : FocusObject
      {
         var _focus:FocusObject = null;
         var _layer:String = this.HIGHEST_LAYER;
         var _priority:String = FocusPriority.MAXIMUM;
         while(_focus == null)
         {
            if(_priority == FocusPriority.MINIMUM)
            {
               if(_layer == this.LOWEST_LAYER)
               {
                  return this.mCurrentFocus;
               }
               _layer = this.getPrevLayer(_layer);
               _priority = FocusPriority.MAXIMUM;
            }
            else
            {
               _priority = this.getPrevPriority(_priority);
            }
            _focus = this.LAYERS[_layer][_priority];
         }
         return _focus;
      }
      
      public function refresh() : void
      {
         this.deleteCursor();
         if(this.mEnabled && this.mCurrentFocus != null)
         {
            if(!this.mCurrentFocus.isObjectCursorable())
            {
               if(this.mCurrentFocus.getCursorableObject(1) == null)
               {
               }
            }
            this.createCursor();
         }
      }
      
      private function getPrevLayer(_currentLayer:String) : String
      {
         switch(_currentLayer)
         {
            case Layers.POPUPS:
               return Layers.MIDDLE;
            case Layers.MIDDLE:
               return Layers.TASKBAR;
            case Layers.TASKBAR:
               return Layers.TASKBAR;
            default:
               return Layers.TASKBAR;
         }
      }
      
      private function getPrevPriority(_currentPriority:String) : String
      {
         switch(_currentPriority)
         {
            case FocusPriority.MAXIMUM:
               return FocusPriority.REGULAR;
            case FocusPriority.REGULAR:
               return FocusPriority.MINIMUM;
            case FocusPriority.MINIMUM:
               return FocusPriority.MINIMUM;
            default:
               return FocusPriority.MINIMUM;
         }
      }
      
      private function validateLayer(_layer:String) : Boolean
      {
         switch(_layer)
         {
            case Layers.POPUPS:
               return true;
            case Layers.MIDDLE:
               return true;
            case Layers.TASKBAR:
               return true;
            default:
               return false;
         }
      }
      
      private function validatePriority(_priority:String) : Boolean
      {
         switch(_priority)
         {
            case FocusPriority.MAXIMUM:
               return true;
            case FocusPriority.REGULAR:
               return true;
            case FocusPriority.MINIMUM:
               return true;
            default:
               return false;
         }
      }
      
      private function createCursor() : void
      {
         if(this.mCursorTimeout.running)
         {
            if(this.mCurrentFocus != null)
            {
               if(this.mCurrentFocus.focusCallBack != null)
               {
                  this.mCurrentFocus.focusCallBack({
                     "type":FocusType.CHANGE,
                     "value":true
                  });
               }
               this.mBorderObject = this.mCurrentFocus.getCursorableObject();
            }
            if(this.mBorderObject != null)
            {
               if(this.mBorderObject.hasOwnProperty("cursor"))
               {
                  if(this.mBorderObject.cursor is TextField)
                  {
                     Skin.style.applyStyle(this.mBorderObject.cursor,Skin.style.currentTheme.cursorGlow);
                  }
                  else
                  {
                     this.mBorderObject.cursor.visible = true;
                  }
               }
               else
               {
                  this.mBorderObject.filters = [this.mBorderFilter];
               }
            }
         }
      }
      
      private function deleteCursor() : void
      {
         if(this.mCurrentFocus != null && this.mCurrentFocus.focusCallBack != null)
         {
            this.mCurrentFocus.focusCallBack({
               "type":FocusType.CHANGE,
               "value":false
            });
         }
         if(this.mBorderObject != null)
         {
            if(this.mBorderObject.hasOwnProperty("cursor"))
            {
               if(this.mBorderObject.cursor is TextField)
               {
                  this.mBorderObject.cursor.filters = [];
               }
               else
               {
                  this.mBorderObject.cursor.visible = false;
               }
            }
            else
            {
               this.mBorderObject.filters = [];
            }
            this.mBorderObject = null;
         }
      }
   }
}

