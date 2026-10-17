package core.api
{
   import core.enums.Alphabet;
   import core.enums.Keyboard;
   import core.enums.Keypad;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   
   public interface IKeyboards extends IEventDispatcher
   {
      
      function getAlphabet(param1:int) : Alphabet;
      
      function getAJKeypad(param1:int) : Keypad;
      
      function getKeyboard(param1:int) : Keyboard;
      
      function getAllAlphabets() : Dictionary;
      
      function getAllAJKeypads() : Dictionary;
      
      function getAllKeyboards() : Dictionary;
      
      function getKeypadByAlphabet(param1:int) : Keypad;
      
      function getKeyboardByAlphabet(param1:int) : Keyboard;
      
      function get activeAJKeys() : Array;
      
      function get activeKeys() : Array;
      
      function get defaultAlphabet() : int;
      
      function set defaultAlphabet(param1:int) : void;
      
      function get activeAJ() : Keypad;
      
      function set activeAJ(param1:Keypad) : void;
      
      function get activeKeyboard() : Keyboard;
      
      function set activeKeyboard(param1:Keyboard) : void;
      
      function get activeNumericAJKeypad() : Keypad;
      
      function set activeNumericAJKeypad(param1:Keypad) : void;
      
      function get activeNumericKeyboard() : Keyboard;
      
      function set activeNumericKeyboard(param1:Keyboard) : void;
      
      function get shift() : Boolean;
      
      function set shift(param1:Boolean) : void;
      
      function get numericAJ() : Boolean;
      
      function set numericAJ(param1:Boolean) : void;
      
      function get numeric() : Boolean;
      
      function set numeric(param1:Boolean) : void;
      
      function get extended() : Boolean;
      
      function set extended(param1:Boolean) : void;
      
      function get smartKeyboardEnabled() : Boolean;
      
      function set smartKeyboardEnabled(param1:Boolean) : void;
      
      function toggleKeypad() : void;
      
      function toggleKeyboard() : void;
      
      function switchToBusiestAJKeypad(param1:String = "") : void;
      
      function switchToBusiestKeyboard(param1:String = "", param2:Boolean = false) : void;
      
      function overrideSmartSpeller(param1:Boolean) : void;
   }
}

