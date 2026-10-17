package core.api
{
   import core.enums.Alphabet;
   import core.enums.Keyboard;
   import core.enums.Keypad;
   import core.events.FrameworkEvent;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public dynamic class Keyboards extends EventDispatcher implements IKeyboards
   {
      
      public static const ALL_CHARACTERS:String = "АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЫЭЮЯЁЙЪЬабвгдежзиклмнопрстуфхцчшщыэюяёйьъ " + "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" + "1234567890-!@#$%^&*()_=+[]{}\\/?><.,|;\':\"" + "ÀÂÃÈÊÌÎÇÑÓÚÜßÕÁÄÅÉËÍÏÆÒÔÙÛÝÖØáäåéëíïæòôùûýöøàâãèêìîçñóúüßõ" + "ضصقفغعهخحجشسيبلﻻاتنمكءئؤإأظطذدزروةث";
      
      public static const SHIFT_KEY:int = 20;
      
      public static const SHIFT_CHR:String = "^";
      
      public static const ALPHABET_LATIN:int = 0;
      
      public static const ALPHABET_CYRILLIC:int = 1;
      
      public static const ALPHABET_ARABIC:int = 2;
      
      public static const ALPHABET_NUMERIC:int = 3;
      
      public static const KEYBRD_ABC:int = 0;
      
      public static const KEYBRD_QWERTY:int = 1;
      
      public static const KEYBRD_AZERTY:int = 2;
      
      public static const KEYBRD_CYRILLIC:int = 3;
      
      public static const KEYBRD_ARABIC:int = 4;
      
      public static const KEYBRD_NUMERIC:int = 5;
      
      public static const KEYPAD_ABC:int = 0;
      
      public static const KEYPAD_CYRILLIC:int = 1;
      
      public static const KEYPAD_ARABIC:int = 2;
      
      public static const KEYPAD_NUMERIC:int = 3;
      
      private static const ABC_UPPER:Array = new Array("AÀÁÂÄÃÅÆ","B","CÇ","D","EÈÉÊË","F","G","H","IÌÍÎÏ","J","K","L","M","NÑ","OÒÓÔÖÕØ","P","Q","R","Sß","T","^","UÙÚÛÜ","V","W","X","YÝ","Z","","","","À","Á","Â","Ä","Ã","Å","È","É","Ê","Ë","Ì","Í","Î","Ï","Ç","Æ","Ñ","Ò","Ó","Ô","^","Ù","Ú","Û","Ü","Ý","ß","Ö","Õ","Ø");
      
      private static const ABC_LOWER:Array = new Array("aàáâäãåæ","b","cç","d","eèéêë","f","g","h","iìíîï","j","k","l","m","nñ","oòóôöõø","p","q","r","sß","t","^","uùúûü","v","w","x","yý","z","","","","à","á","â","ä","ã","å","è","é","ê","ë","ì","í","î","ï","c","æ","ñ","ò","ó","ô","^","ù","ú","û","ü","ý","ß","ö","õ","ø");
      
      private static const QWERTY_UPPER:Array = new Array("Q","W","EÈÉÊË","R","T","YÝ","UÙÚÛÜ","IÌÍÎÏ","OÒÓÔÖÕØ","P","AÀÁÂÄÃÅÆ","Sß","D","F","G","H","J","K","L","","^","Z","X","CÇ","V","B","NÑ","M","","","À","Á","Â","Ä","Ã","Å","È","É","Ê","Ë","Ì","Í","Î","Ï","Ç","Æ","Ñ","Ò","Ó","Ô","^","Ù","Ú","Û","Ü","Ý","ß","Ö","Õ","Ø");
      
      private static const QWERTY_LOWER:Array = new Array("q","w","eèéêë","r","t","yý","uùúûü","iìíîï","oòóôöõø","p","aàáâäãåæ","sß","d","f","g","h","j","k","l","","^","z","x","cç","v","b","nñ","m","","","à","á","â","ä","ã","å","è","é","ê","ë","ì","í","î","ï","c","æ","ñ","ò","ó","ô","^","ù","ú","û","ü","ý","ß","ö","õ","ø");
      
      private static const AZERTY_UPPER:Array = new Array("AÀÁÂÄÃÅÆ","Z","EÈÉÊË","R","T","YÝ","UÙÚÛÜ","IÌÍÎÏ","OÒÓÔÖÕØ","P","Q","Sß","D","F","G","H","J","K","L","M","^","W","X","CÇ","V","B","NÑ","","","","À","Á","Â","Ä","Ã","Å","È","É","Ê","Ë","Ì","Í","Î","Ï","Ç","Æ","Ñ","Ò","Ó","Ô","^","Ù","Ú","Û","Ü","Ý","ß","Ö","Õ","Ø");
      
      private static const AZERTY_LOWER:Array = new Array("aàáâäãåæ","z","eèéêë","r","t","yý","uùúûü","iìíîï","oòóôöõø","p","q","sß","d","f","g","h","j","k","l","m","^","w","x","cç","v","b","nñ","","","","à","á","â","ä","ã","å","è","é","ê","ë","ì","í","î","ï","c","æ","ñ","ò","ó","ô","^","ù","ú","û","ü","ý","ß","ö","õ","ø");
      
      private static const CYRILLIC_UPPER:Array = new Array("Ц","У","К","ЕЁ","Н","Г","ШЩ","Э","З","Х","Ф","Ы","В","А","П","Р","О","Л","Д","Ж","^","Я","Ч","С","М","ИЙ","Т","ЬЪ","Б","Ю","Ё","Щ","Й","Ъ","","","","","","","","","","","","","","","","","^","","","","","","","","","");
      
      private static const CYRILLIC_LOWER:Array = new Array("ц","у","к","её","н","г","шщ","э","з","х","ф","ы","в","а","п","р","о","л","д","ж","^","я","ч","с","м","ий","т","ьъ","б","ю","ё","щ","й","ъ","","","","","","","","","","","","","","","","","^","","","","","","","","","");
      
      private static const ARABIC:Array = new Array("ض","ص","ق","ف","غ","ع","ه","خ","ح","ج","ش","س","ي","ب","لﻻ","ا","ت","ن","م","ك","ءئؤإأ","ظ","ط","ذ","د","ز","ر","و","ة","ث","ﻻ","أ","ئ","ؤ","ء","","","","","","","","","","","","","","","","","","","","","","","","","");
      
      private static const NUMERIC:Array = new Array("1","2","3","4","5","6","7","8","9","0","+","-","*","/","(",")","=","\"","\'","&","$","%","#","@",",",".","?","!",";",":");
      
      private static const AJ_ABC:Array = new Array("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z");
      
      private static const AJ_CYRILLIC:Array = new Array("A","Б","В","Г","Д","E","Ё","Ж","З","И","Й","К","Л","М","Н","О","П","Р","С","T","У","Ф","Х","Ц","Ч","Ш","Щ");
      
      private static const AJ_ARABIC:Array = new Array("ض","ص","ق","ف","غ","ع","ه","خ","ح","ج","ش","س","ي","ب","ل","ا","ت","ن","م","ك","ئ","ؤ","إ","أ","ظ","ط","ذ","د","ز","ر","و","ة","ث");
      
      private static const AJ_NUMERIC:Array = new Array("1","2","3","4","5","6","7","8","9","0");
      
      private var mAvailableUpperAlphabet:int = 0;
      
      private var mAvailableLowerAlphabet:int = 0;
      
      private var mAvailableUpperCyrillic:int = 0;
      
      private var mAvailableLowerCyrillic:int = 0;
      
      private var mAvailableArabic:int = 0;
      
      private var mAvailableNumeric:int = 0;
      
      private var mAllAlphabets:Dictionary = new Dictionary();
      
      private var mAllKeyboards:Dictionary = new Dictionary();
      
      private var mAllAJKeypads:Dictionary = new Dictionary();
      
      private var mDefaultAlphabet:int = ALPHABET_LATIN;
      
      private var mActiveKeyboard:Keyboard = this.getKeyboardByAlphabet(ALPHABET_LATIN);
      
      private var mActiveNumericKeyboard:Keyboard = this.mAllKeyboards[KEYBRD_NUMERIC];
      
      private var mActiveAJKeypad:Keypad = this.getKeypadByAlphabet(ALPHABET_LATIN);
      
      private var mActiveNumericAJKeypad:Keypad = this.mAllAJKeypads[KEYPAD_NUMERIC];
      
      private var mShift:Boolean = false;
      
      private var mNumeric:Boolean = false;
      
      private var mExtended:Boolean = false;
      
      private var mNumericAJ:Boolean = false;
      
      private var mSmartKeyboardEnabled:Boolean = true;
      
      private var mTempSmartKeyboardEnabled:Boolean = true;
      
      public function Keyboards()
      {
         this.mAllAlphabets[ALPHABET_LATIN] = new Alphabet(ALPHABET_LATIN,"Latin",KEYPAD_ABC,KEYBRD_QWERTY);
         this.mAllAlphabets[ALPHABET_CYRILLIC] = new Alphabet(ALPHABET_CYRILLIC,"Cyrillic",KEYPAD_CYRILLIC,KEYBRD_CYRILLIC);
         this.mAllAlphabets[ALPHABET_ARABIC] = new Alphabet(ALPHABET_ARABIC,"Arabic",KEYPAD_ARABIC,KEYBRD_ARABIC);
         this.mAllAlphabets[ALPHABET_NUMERIC] = new Alphabet(ALPHABET_NUMERIC,"Numeric",KEYPAD_NUMERIC,KEYBRD_NUMERIC);
         this.mAllAJKeypads[KEYPAD_ABC] = new Keypad(KEYPAD_ABC,ALPHABET_LATIN,"A B C",AJ_ABC);
         this.mAllAJKeypads[KEYPAD_CYRILLIC] = new Keypad(KEYPAD_CYRILLIC,ALPHABET_CYRILLIC,"А Б В",AJ_CYRILLIC);
         this.mAllAJKeypads[KEYPAD_ARABIC] = new Keypad(KEYPAD_ARABIC,ALPHABET_ARABIC,"ض ص ق",AJ_ARABIC);
         this.mAllAJKeypads[KEYPAD_NUMERIC] = new Keypad(KEYPAD_NUMERIC,ALPHABET_NUMERIC,"1 2 3",AJ_NUMERIC);
         this.mAllKeyboards[KEYBRD_ABC] = new Keyboard(KEYBRD_ABC,ALPHABET_LATIN,"ABCDEF","A B C","ÅØÜ",ABC_LOWER,ABC_UPPER);
         this.mAllKeyboards[KEYBRD_QWERTY] = new Keyboard(KEYBRD_QWERTY,ALPHABET_LATIN,"QWERTY","Q W E","ÅØÜ",QWERTY_LOWER,QWERTY_UPPER);
         this.mAllKeyboards[KEYBRD_AZERTY] = new Keyboard(KEYBRD_AZERTY,ALPHABET_LATIN,"AZERTY","A Z E","ÅØÜ",AZERTY_LOWER,AZERTY_UPPER);
         this.mAllKeyboards[KEYBRD_CYRILLIC] = new Keyboard(KEYBRD_CYRILLIC,ALPHABET_CYRILLIC,"ЦУКЕНГ","Ц У К","ЁЩЙ",CYRILLIC_LOWER,CYRILLIC_UPPER);
         this.mAllKeyboards[KEYBRD_ARABIC] = new Keyboard(KEYBRD_ARABIC,ALPHABET_ARABIC,"ضصقفغ","ض ص ق","ﻻأئ",ARABIC);
         this.mAllKeyboards[KEYBRD_NUMERIC] = new Keyboard(KEYBRD_NUMERIC,ALPHABET_NUMERIC,"123456","1 2 3","123",NUMERIC);
         super();
      }
      
      public function getAlphabet(_id:int) : Alphabet
      {
         return this.mAllAlphabets[_id];
      }
      
      public function getAJKeypad(_id:int) : Keypad
      {
         return this.mAllAJKeypads[_id];
      }
      
      public function getKeyboard(_id:int) : Keyboard
      {
         return this.mAllKeyboards[_id];
      }
      
      public function getAllAlphabets() : Dictionary
      {
         return this.mAllAlphabets;
      }
      
      public function getAllAJKeypads() : Dictionary
      {
         return this.mAllAJKeypads;
      }
      
      public function getAllKeyboards() : Dictionary
      {
         return this.mAllKeyboards;
      }
      
      public function getKeypadByAlphabet(_alphabet:int) : Keypad
      {
         return this.mAllAJKeypads[this.mAllAlphabets[_alphabet].keypad];
      }
      
      public function getKeyboardByAlphabet(_alphabet:int) : Keyboard
      {
         return this.mAllKeyboards[this.mAllAlphabets[_alphabet].keyboard];
      }
      
      public function get activeAJKeys() : Array
      {
         if(this.mNumericAJ)
         {
            return this.mActiveNumericAJKeypad.characters;
         }
         return this.mActiveAJKeypad.characters;
      }
      
      public function get activeKeys() : Array
      {
         if(this.mNumeric)
         {
            return this.mActiveNumericKeyboard.lower;
         }
         if(this.mShift && Boolean(this.mActiveKeyboard.upper))
         {
            if(this.mExtended)
            {
               return this.mActiveKeyboard.upper.slice(30,this.mActiveKeyboard.upper.length);
            }
            return this.mActiveKeyboard.upper;
         }
         if(this.mExtended)
         {
            return this.mActiveKeyboard.lower.slice(30,this.mActiveKeyboard.lower.length);
         }
         return this.mActiveKeyboard.lower;
      }
      
      public function get defaultAlphabet() : int
      {
         return this.mDefaultAlphabet;
      }
      
      public function set defaultAlphabet(_alphabet:int) : void
      {
         this.mActiveKeyboard = this.getKeyboardByAlphabet(_alphabet);
         this.mActiveAJKeypad = this.getKeypadByAlphabet(_alphabet);
         this.mDefaultAlphabet = _alphabet;
      }
      
      public function get activeAJ() : Keypad
      {
         return this.mActiveAJKeypad;
      }
      
      public function set activeAJ(_keypad:Keypad) : void
      {
         if(this.mActiveAJKeypad.id != _keypad.id)
         {
            this.mActiveAJKeypad = _keypad;
            dispatchEvent(new FrameworkEvent(FrameworkEvent.KEYPAD_CHANGED));
         }
      }
      
      public function get activeKeyboard() : Keyboard
      {
         return this.mActiveKeyboard;
      }
      
      public function set activeKeyboard(_keyboard:Keyboard) : void
      {
         if(this.mActiveKeyboard.id != _keyboard.id)
         {
            this.mShift = _keyboard.upper != null;
            this.mNumeric = false;
            this.mExtended = false;
            this.mActiveKeyboard = _keyboard;
            dispatchEvent(new FrameworkEvent(FrameworkEvent.KEYBOARD_CHANGED));
         }
      }
      
      public function get activeNumericAJKeypad() : Keypad
      {
         return this.mActiveNumericAJKeypad;
      }
      
      public function set activeNumericAJKeypad(_keypad:Keypad) : void
      {
         this.mActiveNumericAJKeypad = _keypad;
      }
      
      public function get activeNumericKeyboard() : Keyboard
      {
         return this.mActiveNumericKeyboard;
      }
      
      public function set activeNumericKeyboard(_keyboard:Keyboard) : void
      {
         this.mActiveNumericKeyboard = _keyboard;
      }
      
      public function get shift() : Boolean
      {
         return this.mShift;
      }
      
      public function set shift(_shift:Boolean) : void
      {
         if(this.mShift != _shift)
         {
            this.mShift = _shift;
            dispatchEvent(new FrameworkEvent(FrameworkEvent.KEYBOARD_CHANGED));
         }
      }
      
      public function get numericAJ() : Boolean
      {
         return this.mNumericAJ;
      }
      
      public function set numericAJ(_numericAJ:Boolean) : void
      {
         if(this.mNumericAJ != _numericAJ)
         {
            this.mNumericAJ = _numericAJ;
            dispatchEvent(new FrameworkEvent(FrameworkEvent.KEYPAD_CHANGED));
         }
      }
      
      public function get numeric() : Boolean
      {
         return this.mNumeric;
      }
      
      public function set numeric(_numeric:Boolean) : void
      {
         if(this.mNumeric != _numeric)
         {
            this.mExtended = false;
            this.mNumeric = _numeric;
            dispatchEvent(new FrameworkEvent(FrameworkEvent.KEYBOARD_CHANGED));
         }
      }
      
      public function get extended() : Boolean
      {
         return this.mExtended;
      }
      
      public function set extended(_extended:Boolean) : void
      {
         if(this.mExtended != _extended)
         {
            this.mNumeric = false;
            this.mExtended = _extended;
            dispatchEvent(new FrameworkEvent(FrameworkEvent.KEYBOARD_CHANGED));
         }
      }
      
      public function get smartKeyboardEnabled() : Boolean
      {
         return this.mSmartKeyboardEnabled;
      }
      
      public function set smartKeyboardEnabled(_enabled:Boolean) : void
      {
         if(!_enabled)
         {
            this.mActiveKeyboard = this.getKeyboardByAlphabet(this.mDefaultAlphabet);
            this.mActiveAJKeypad = this.getKeypadByAlphabet(this.mDefaultAlphabet);
         }
         this.mSmartKeyboardEnabled = _enabled;
      }
      
      public function toggleKeypad() : void
      {
         var alphabet:Alphabet = null;
         var keypads:Array = new Array();
         var i:int = 0;
         var index:int = 0;
         for each(alphabet in this.mAllAlphabets)
         {
            if(alphabet.id != ALPHABET_NUMERIC && alphabet.available)
            {
               keypads.push(alphabet.keypad);
               if(this.mActiveAJKeypad.id == alphabet.keypad)
               {
                  index = i + 1;
               }
               i++;
            }
         }
         this.mNumericAJ = false;
         this.mActiveAJKeypad = this.mAllAJKeypads[keypads[index < keypads.length ? index : 0]];
         dispatchEvent(new FrameworkEvent(FrameworkEvent.KEYPAD_CHANGED));
      }
      
      public function toggleKeyboard() : void
      {
         var alphabet:Alphabet = null;
         var keyboards:Array = new Array();
         var i:int = 0;
         var index:int = 0;
         for each(alphabet in this.mAllAlphabets)
         {
            if(alphabet.id != ALPHABET_NUMERIC && alphabet.available)
            {
               keyboards.push(alphabet.keyboard);
               if(this.mActiveKeyboard.id == alphabet.keyboard)
               {
                  index = i + 1;
               }
               i++;
            }
         }
         this.mNumeric = false;
         this.mExtended = false;
         this.mActiveKeyboard = this.mAllKeyboards[keyboards[index < keyboards.length ? index : 0]];
         this.mShift = this.activeKeys[SHIFT_KEY] == SHIFT_CHR;
         dispatchEvent(new FrameworkEvent(FrameworkEvent.KEYBOARD_CHANGED));
      }
      
      public function switchToBusiestAJKeypad(_characters:String = "") : void
      {
         var _keypads:Array = this.sortDictionaryByAlphabet(this.mAllAlphabets);
         for(var i:int = 0; i < _keypads.length; i++)
         {
            if(this.isKeypadAvailable(this.mAllAJKeypads[_keypads[i].keypad],_characters))
            {
               return;
            }
         }
      }
      
      public function overrideSmartSpeller(_enable:Boolean) : void
      {
         if(_enable)
         {
            this.mTempSmartKeyboardEnabled = this.mSmartKeyboardEnabled;
            this.mSmartKeyboardEnabled = true;
         }
         else
         {
            this.mSmartKeyboardEnabled = this.mTempSmartKeyboardEnabled;
         }
      }
      
      public function switchToBusiestKeyboard(_characters:String = "", _stickToNumeric:Boolean = false) : void
      {
         if(ALL_CHARACTERS == _characters)
         {
            return;
         }
         var _keyboards:Array = this.sortDictionaryByAlphabet(this.mAllAlphabets);
         if(_stickToNumeric && this.mNumeric)
         {
            _keyboards.unshift(_keyboards.pop());
         }
         for(var i:int = 0; i < _keyboards.length; i++)
         {
            if(this.isKeyboardAvailable(this.mAllKeyboards[_keyboards[i].keyboard],_characters))
            {
               return;
            }
         }
      }
      
      private function isKeypadAvailable(_keypad:Keypad, _characters:String) : Boolean
      {
         var _availableCharacters:int = 0;
         var i:int = 0;
         var j:int = 0;
         if(this.mSmartKeyboardEnabled)
         {
            _availableCharacters = 0;
            for(i = 0; i < _characters.length; i++)
            {
               for(j = 0; j < _keypad.characters.length; j++)
               {
                  if(_characters.charAt(i) == _keypad.characters[j])
                  {
                     _availableCharacters++;
                  }
               }
            }
            if(_availableCharacters != 0)
            {
               this.mNumericAJ = _keypad.alphabet == ALPHABET_NUMERIC;
               if(!this.mNumericAJ)
               {
                  this.mActiveAJKeypad = _keypad;
               }
               dispatchEvent(new FrameworkEvent(FrameworkEvent.KEYPAD_CHANGED));
               return true;
            }
            return false;
         }
         dispatchEvent(new FrameworkEvent(FrameworkEvent.KEYPAD_CHANGED));
         return true;
      }
      
      private function isKeyboardAvailable(_keyboard:Keyboard, _characters:String) : Boolean
      {
         var _availableUpper:int = 0;
         var _availableLower:int = 0;
         var j:int = 0;
         var k:int = 0;
         var i:int = 0;
         var _shift:Boolean = this.mShift;
         var _numeric:Boolean = this.mNumeric;
         var _extended:Boolean = this.mExtended;
         if(this.mSmartKeyboardEnabled)
         {
            _availableUpper = 0;
            _availableLower = 0;
            j = 0;
            k = 0;
            for(i = 0; i < _characters.length; i++)
            {
               if(_keyboard.upper != null)
               {
                  for(j = 0; j < _keyboard.upper.length; j++)
                  {
                     for(k = 0; k < _keyboard.upper[j].length; k++)
                     {
                        if(_characters.charAt(i) == String(_keyboard.upper[j]).charAt(k))
                        {
                           _availableUpper++;
                        }
                     }
                  }
               }
               if(_keyboard.lower != null)
               {
                  for(j = 0; j < _keyboard.lower.length; j++)
                  {
                     for(k = 0; k < _keyboard.lower[j].length; k++)
                     {
                        if(_characters.charAt(i) == String(_keyboard.lower[j]).charAt(k))
                        {
                           _availableLower++;
                        }
                     }
                  }
               }
            }
            if(_availableLower > 0 || _availableUpper > 0)
            {
               if(_availableLower == _availableUpper)
               {
                  return true;
               }
               if(_availableLower > 0 && _availableLower > _availableUpper)
               {
                  _shift = _keyboard.alphabet == ALPHABET_NUMERIC ? this.mShift : false;
                  _numeric = _keyboard.alphabet == ALPHABET_NUMERIC;
                  _extended = false;
               }
               else if(_availableUpper > 0)
               {
                  _shift = _keyboard.alphabet == ALPHABET_NUMERIC ? this.mShift : true;
                  _numeric = _keyboard.alphabet == ALPHABET_NUMERIC;
                  _extended = false;
               }
               if(this.mShift != _shift || this.mNumeric != _numeric || this.mActiveKeyboard.id != _keyboard.id || this.mExtended != _extended)
               {
                  this.mShift = _shift;
                  this.mNumeric = _numeric;
                  this.mExtended = _extended;
                  if(!_numeric)
                  {
                     this.mActiveKeyboard = _keyboard;
                  }
                  dispatchEvent(new FrameworkEvent(FrameworkEvent.KEYBOARD_CHANGED));
               }
               return true;
            }
            return false;
         }
         dispatchEvent(new FrameworkEvent(FrameworkEvent.KEYBOARD_CHANGED));
         return true;
      }
      
      private function sortDictionaryByAlphabet(_dictionary:Dictionary) : Array
      {
         var alphabet:Alphabet = null;
         var a:Array = new Array();
         for each(alphabet in _dictionary)
         {
            if(alphabet.id == this.mDefaultAlphabet)
            {
               a.unshift(alphabet);
            }
            else if(this.smartKeyboardEnabled)
            {
               a.push(alphabet);
            }
         }
         return a;
      }
   }
}

