package peripheral
{
   import com.harman.moduleLinkAPI.PersistencyEvent;
   import com.harman.moduleLinkAPI.PersistencyKeys;
   import com.nfuzion.framework.global.Framework;
   import core.api.Keyboards;
   import core.enums.Market;
   
   public class PersistencyManager
   {
      
      public function PersistencyManager()
      {
         super();
         Peripheral.persistency.addEventListener(PersistencyKeys.KEY_KEYBOARD,this.onKeyboard);
         Peripheral.persistency.read(PersistencyKeys.KEY_KEYBOARD);
         Framework.keyboards.getAlphabet(Keyboards.ALPHABET_ARABIC).available = Peripheral.versionInfo.productVariantID.VARIANT_MARKET == "ROW";
         Framework.keyboards.getAlphabet(Keyboards.ALPHABET_CYRILLIC).available = Peripheral.versionInfo.productVariantID.VARIANT_MARKET == "ROW" || Peripheral.versionInfo.productVariantID.VARIANT_MARKET == "ECE" || Peripheral.versionInfo.productVariantID.VARIANT_MARKET == "TU";
      }
      
      private function onKeyboard(e:PersistencyEvent) : void
      {
         if(e.value.hasOwnProperty("err"))
         {
            Framework.Trace("onKeyboard: Error: " + e.value.err);
            return;
         }
         var _value:String = String(e.value);
         Framework.keyboards.smartKeyboardEnabled = _value.charAt(0) == "1";
         Framework.keyboards.getAlphabet(Keyboards.ALPHABET_LATIN).keyboard = int(_value.charAt(2));
         Framework.keyboards.getAlphabet(Keyboards.ALPHABET_CYRILLIC).keyboard = int(_value.charAt(3));
         Framework.keyboards.getAlphabet(Keyboards.ALPHABET_ARABIC).keyboard = int(_value.charAt(4));
         this.validateAlphabet(int(_value.charAt(1)));
      }
      
      public function saveKeyboardSettings() : void
      {
         var _write:String = Framework.keyboards.smartKeyboardEnabled ? "1" : "0";
         _write += Framework.keyboards.defaultAlphabet.toString();
         _write += Framework.keyboards.getKeyboardByAlphabet(Keyboards.ALPHABET_LATIN).id;
         _write += Framework.keyboards.getKeyboardByAlphabet(Keyboards.ALPHABET_CYRILLIC).id;
         _write += Framework.keyboards.getKeyboardByAlphabet(Keyboards.ALPHABET_ARABIC).id;
         Peripheral.persistency.write(PersistencyKeys.KEY_KEYBOARD,_write);
      }
      
      private function validateAlphabet(_alphabet:int) : void
      {
         switch(_alphabet)
         {
            case Keyboards.ALPHABET_LATIN:
               Framework.keyboards.defaultAlphabet = Keyboards.ALPHABET_LATIN;
               break;
            case Keyboards.ALPHABET_ARABIC:
               if(Global.market == Market.ROW)
               {
                  Framework.keyboards.defaultAlphabet = Keyboards.ALPHABET_ARABIC;
               }
               else
               {
                  Framework.keyboards.defaultAlphabet = Keyboards.ALPHABET_LATIN;
                  this.saveKeyboardSettings();
               }
               break;
            case Keyboards.ALPHABET_CYRILLIC:
               if(Global.market == Market.ROW || Global.market == Market.EUROPE)
               {
                  Framework.keyboards.defaultAlphabet = Keyboards.ALPHABET_CYRILLIC;
               }
               else
               {
                  Framework.keyboards.defaultAlphabet = Keyboards.ALPHABET_LATIN;
                  this.saveKeyboardSettings();
               }
               break;
            default:
               Framework.keyboards.defaultAlphabet = Keyboards.ALPHABET_LATIN;
               this.saveKeyboardSettings();
         }
      }
   }
}

