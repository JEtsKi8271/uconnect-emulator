package core.utils
{
   import flash.text.*;
   
   public class ArabicScript
   {
      
      private static var INITIAL:String = "initial";
      
      private static var MEDIAL:String = "medial";
      
      private static var ISOLATED:String = "isolated";
      
      private static var FINAL:String = "finalchar";
      
      private static var rightToLeftUnicodeRanges:Array = [{
         "from":1424,
         "to":2303
      },{
         "from":64336,
         "to":65023
      },{
         "from":65136,
         "to":65279
      },{
         "from":67584,
         "to":69631
      }];
      
      private static var emojiSurrogateRanges:Array = [{
         "from":55296,
         "to":57343
      }];
      
      private static var neutralChars:Array = [".",":"," ","\t","\r","\n","_",",","(",")","-","&","…","/","!","?","#","*"];
      
      private static var numeralChars:Array = ["0","1","2","3","4","5","6","7","8","9","-"];
      
      private static var forms:Object = {
         "x622":{"finalchar":"ﺂ"},
         "x623":{"finalchar":"ﺄ"},
         "x624":{
            "medial":"ﺅ",
            "finalchar":"ﺆ"
         },
         "x625":{"finalchar":"ﺇ"},
         "x626":{
            "initial":"ﺋ",
            "medial":"ﺌ",
            "finalchar":"ئ"
         },
         "x627":{"finalchar":"ﺎ"},
         "x628":{
            "initial":"ﺑ",
            "medial":"ﺒ",
            "finalchar":"ﺐ"
         },
         "x629":{"finalchar":"ﺔ"},
         "x62a":{
            "initial":"ﺗ",
            "medial":"ﺘ",
            "finalchar":"ﺖ"
         },
         "x62b":{
            "initial":"ﺛ",
            "medial":"ﺜ",
            "finalchar":"ﺚ"
         },
         "x62c":{
            "initial":"ﺟ",
            "medial":"ﺠ",
            "finalchar":"ﺞ"
         },
         "x62d":{
            "initial":"ﺣ",
            "medial":"ﺤ",
            "finalchar":"ﺢ"
         },
         "x62e":{
            "initial":"ﺧ",
            "medial":"ﺨ",
            "finalchar":"ﺦ"
         },
         "x62f":{"finalchar":"ﺪ"},
         "x630":{"finalchar":"ﺬ"},
         "x631":{"finalchar":"ﺮ"},
         "x632":{"finalchar":"ﺰ"},
         "x633":{
            "initial":"ﺳ",
            "medial":"ﺴ",
            "finalchar":"ﺲ"
         },
         "x634":{
            "initial":"ﺷ",
            "medial":"ﺸ",
            "finalchar":"ﺶ"
         },
         "x635":{
            "initial":"ﺻ",
            "medial":"ﺼ",
            "finalchar":"ﺺ"
         },
         "x636":{
            "initial":"ﺿ",
            "medial":"ﻀ",
            "finalchar":"ﺾ"
         },
         "x637":{
            "initial":"ﻃ",
            "medial":"ﻄ",
            "finalchar":"ﻂ"
         },
         "x638":{
            "initial":"ﻇ",
            "medial":"ﻈ",
            "finalchar":"ﻆ"
         },
         "x639":{
            "initial":"ﻋ",
            "medial":"ﻌ",
            "finalchar":"ﻊ"
         },
         "x63a":{
            "initial":"ﻏ",
            "medial":"ﻐ",
            "finalchar":"ﻎ"
         },
         "x641":{
            "initial":"ﻓ",
            "medial":"ﻔ",
            "finalchar":"ﻒ"
         },
         "x642":{
            "initial":"ﻗ",
            "medial":"ﻘ",
            "finalchar":"ﻖ"
         },
         "x643":{
            "initial":"ﻛ",
            "medial":"ﻜ",
            "finalchar":"ﻚ"
         },
         "x644":{
            "initial":"ﻟ",
            "medial":"ﻠ",
            "finalchar":"ﻞ"
         },
         "x64f":{"medial":"ﹹ"},
         "x645":{
            "initial":"ﻣ",
            "medial":"ﻤ",
            "finalchar":"ﻢ"
         },
         "x646":{
            "initial":"ﻧ",
            "medial":"ﻨ",
            "finalchar":"ﻦ"
         },
         "x647":{
            "initial":"ﻫ",
            "medial":"ﻬ",
            "finalchar":"ﻪ"
         },
         "x64b":{"medial":"ً"},
         "x64f":{"medial":"ﹹ"},
         "x648":{"finalchar":"ﻮ"},
         "x649":{"finalchar":"ﻰ"},
         "x64a":{
            "initial":"ﻳ",
            "medial":"ﻴ",
            "finalchar":"ﻲ"
         },
         "x6a9":{
            "initial":"ﮐ",
            "medial":"ﮑ",
            "finalchar":"ﮏ"
         },
         "x651":{"medial":"ﹽ"},
         "xfef5":{"finalchar":"ﻶ"},
         "xfef7":{"finalchar":"ﻸ"},
         "xfef9":{"finalchar":"ﻺ"},
         "xfefb":{"finalchar":"ﻼ"},
         "x64e":{"ignore":true},
         "x64f":{"ignore":true},
         "x650":{"ignore":true},
         "x651":{"ignore":true},
         "x652":{"ignore":true}
      };
      
      public function ArabicScript()
      {
         super();
      }
      
      public static function getTransformedString(string:String, rightToLeft:Boolean) : String
      {
         var chars:Array = null;
         var charCodeHex:String = null;
         var charForms:Object = null;
         var form:String = null;
         var initial:Boolean = false;
         var lastChar:String = null;
         var lastForm:String = null;
         var displayDirection:Number = NaN;
         var firstDisplayDirection:Number = NaN;
         var originalDisplayDirection:Number = NaN;
         var prevDisplayDirection:Number = NaN;
         var beforeNeutralDirection:Number = NaN;
         var rightToLeftFromIndex:Number = NaN;
         var rightToLeftCharRanges:Array = null;
         var lastIndex:Number = NaN;
         var lastRange:Object = null;
         var rightToLeftRange:Object = null;
         var leftToRightChars:Array = null;
         var rightToLeftChars:Array = null;
         var i:Number = NaN;
         var unicode:Number = NaN;
         var rtlChars:String = null;
         if(Boolean(string) && string.length > 1)
         {
            chars = string.split("");
            initial = true;
            firstDisplayDirection = rightToLeft ? -1 : 1;
            rightToLeftFromIndex = -1;
            rightToLeftCharRanges = new Array();
            i = 0;
            while(i < chars.length)
            {
               charCodeHex = String(chars[i]).charCodeAt().toString(16);
               if(charCodeHex == "200d" || charCodeHex == "200f" || charCodeHex == "200e")
               {
                  chars.splice(i,1,"");
               }
               unicode = String(chars[i]).charCodeAt();
               if(unicode >= emojiSurrogateRanges[0].from && unicode <= emojiSurrogateRanges[0].to)
               {
                  chars.splice(i,1," ");
               }
               if(charCodeHex == "644")
               {
                  switch(String(chars[i + 1]).charCodeAt().toString(16))
                  {
                     case "622":
                        chars.splice(i,2,"ﻵ");
                        break;
                     case "623":
                        chars.splice(i,2,"ﻷ");
                        break;
                     case "625":
                        chars.splice(i,2,"ﻹ");
                        break;
                     case "627":
                        chars.splice(i,2,"ﻻ");
                  }
               }
               prevDisplayDirection = originalDisplayDirection;
               originalDisplayDirection = getDisplayDirection(chars[i]);
               displayDirection = originalDisplayDirection;
               if(displayDirection == 0)
               {
                  displayDirection = firstDisplayDirection;
               }
               lastRange = rightToLeftCharRanges[rightToLeftCharRanges.length - 1];
               if(displayDirection < 0)
               {
                  lastIndex = rightToLeftFromIndex < 0 ? i : rightToLeftFromIndex;
                  if(i == chars.length - 1)
                  {
                     if(Boolean(lastRange) && (firstDisplayDirection < 0 && lastIndex - lastRange.to == 2 || firstDisplayDirection > 0 && prevDisplayDirection == 0 && beforeNeutralDirection < 0))
                     {
                        lastRange.to = i;
                     }
                     else if(firstDisplayDirection < 0 || rightToLeftFromIndex >= 0)
                     {
                        rightToLeftCharRanges.push({
                           "from":lastIndex,
                           "to":i
                        });
                     }
                  }
                  if(rightToLeftFromIndex < 0)
                  {
                     rightToLeftFromIndex = i;
                  }
               }
               else if(displayDirection > 0)
               {
                  if(rightToLeftFromIndex >= 0 || prevDisplayDirection < 0)
                  {
                     if((prevDisplayDirection < 0 || firstDisplayDirection < 0 && prevDisplayDirection == 0 && beforeNeutralDirection < 0) && (firstDisplayDirection < 0 || rightToLeftFromIndex < i - 1))
                     {
                        if(prevDisplayDirection < 0 && beforeNeutralDirection < 0)
                        {
                           if(lastRange)
                           {
                              lastRange.to = i;
                           }
                           else
                           {
                              rightToLeftCharRanges.push({
                                 "from":rightToLeftFromIndex,
                                 "to":i - 1
                              });
                           }
                        }
                        else
                        {
                           rightToLeftCharRanges.push({
                              "from":rightToLeftFromIndex,
                              "to":i - 1
                           });
                        }
                     }
                     if(originalDisplayDirection != 0)
                     {
                        rightToLeftFromIndex = -1;
                     }
                  }
               }
               if(originalDisplayDirection == 0 && prevDisplayDirection != originalDisplayDirection)
               {
                  beforeNeutralDirection = prevDisplayDirection;
               }
               charCodeHex = String(chars[i]).charCodeAt().toString(16);
               charForms = forms["x" + charCodeHex];
               if(charForms)
               {
                  form = charForms.ignore;
                  if(form)
                  {
                     if(i == chars.length - 1)
                     {
                        checkLastChar(chars,lastChar,lastForm,i);
                     }
                     i++;
                     continue;
                  }
                  if(initial)
                  {
                     form = charForms.initial;
                     if(form)
                     {
                        lastForm = INITIAL;
                        initial = false;
                     }
                     else
                     {
                        lastForm = ISOLATED;
                     }
                  }
                  else
                  {
                     form = charForms.medial;
                     if(form)
                     {
                        lastForm = MEDIAL;
                     }
                     else
                     {
                        form = charForms.finalchar;
                        if(form)
                        {
                           lastForm = FINAL;
                        }
                        else
                        {
                           checkLastChar(chars,lastChar,lastForm,i);
                        }
                        initial = true;
                     }
                  }
                  lastChar = chars[i];
                  if(form)
                  {
                     chars[i] = form;
                  }
                  if(i == chars.length - 1)
                  {
                     checkLastChar(chars,lastChar,lastForm,i + 1);
                  }
               }
               else if(i > 0 && !initial)
               {
                  checkLastChar(chars,lastChar,lastForm,i);
                  initial = true;
               }
               i++;
            }
            string = "";
            i = rightToLeft ? chars.length : 0;
            while(rightToLeftCharRanges.length > 0)
            {
               rightToLeftRange = rightToLeft ? rightToLeftCharRanges.pop() : rightToLeftCharRanges.shift();
               leftToRightChars = rightToLeft ? chars.slice(rightToLeftRange.to + 1,i) : chars.slice(i,rightToLeftRange.from);
               i = rightToLeft ? Number(rightToLeftRange.from) : rightToLeftRange.to + 1;
               rightToLeftChars = rightToLeft ? chars.slice(i,rightToLeftRange.to + 1) : chars.slice(rightToLeftRange.from,i);
               string += leftToRightChars.join("");
               rightToLeftChars.reverse();
               rtlChars = swapBrackets(rightToLeftChars.join(""),{
                  "open":"<",
                  "close":">"
               });
               string += rtlChars;
            }
            if(!rightToLeft && i < chars.length)
            {
               string += chars.slice(i,chars.length).join("");
            }
            if(rightToLeft && i > 0)
            {
               string += chars.slice(0,i).join("");
            }
            string = swapBrackets(string,{
               "open":"(",
               "close":")"
            });
         }
         return string;
      }
      
      private static function isNumeral(char:String) : Boolean
      {
         for(var i:int = 0; i < numeralChars.length; i++)
         {
            if(numeralChars[i] == char)
            {
               return true;
            }
         }
         return false;
      }
      
      private static function swapBrackets(string:String, bracket:Object) : String
      {
         var bracketSets:int = 0;
         var swapped:int = 0;
         var temp:Array = null;
         var leftBracket:* = string.length;
         var rightBracket:int = -1;
         if(bracket != null && bracket.hasOwnProperty("open") && bracket.hasOwnProperty("close"))
         {
            bracketSets = string.match(new RegExp("[" + bracket.open + bracket.close + "]","g")).length / 2;
            swapped = 0;
            do
            {
               temp = string.split("");
               leftBracket = string.lastIndexOf(bracket.open,leftBracket);
               rightBracket = string.indexOf(bracket.close,rightBracket);
               if(leftBracket != -1 && rightBracket != -1)
               {
                  if(leftBracket > rightBracket)
                  {
                     string = string.slice(0,rightBracket) + bracket.open + string.slice(rightBracket + 1,leftBracket) + bracket.close + string.slice(leftBracket + 1,string.length);
                  }
                  else if(rightBracket > leftBracket)
                  {
                     string = string.slice(0,leftBracket) + bracket.close + string.slice(leftBracket + 1,rightBracket) + bracket.open + string.slice(rightBracket + 1,string.length);
                  }
                  leftBracket--;
                  rightBracket++;
                  swapped++;
               }
            }
            while(swapped < bracketSets && leftBracket != -1 && rightBracket != -1);
         }
         return string;
      }
      
      private static function checkLastChar(chars:Array, lastChar:String, lastForm:String, index:Number) : void
      {
         var form:String = null;
         if(lastForm == MEDIAL)
         {
            form = forms["x" + lastChar.charCodeAt().toString(16)].finalchar;
         }
         if(lastForm == INITIAL)
         {
            form = lastChar;
         }
         if(form)
         {
            chars[index - 1] = form;
         }
      }
      
      private static function getDisplayDirection(char:String) : Number
      {
         var i:Number = NaN;
         var unicode:Number = char.charCodeAt(0);
         i = 0;
         while(i < rightToLeftUnicodeRanges.length)
         {
            if(unicode >= rightToLeftUnicodeRanges[i].from && unicode <= rightToLeftUnicodeRanges[i].to)
            {
               return -1;
            }
            i++;
         }
         i = 0;
         while(i < neutralChars.length)
         {
            if(neutralChars[i] == char)
            {
               return 0;
            }
            i++;
         }
         return 1;
      }
      
      public static function getDetectedDisplayDirection(text:String) : Number
      {
         var _temp1:Number = NaN;
         var i:Number = 0;
         var direction:Number = 0;
         if(text != null)
         {
            while(i < text.length && (direction == 0 || direction == 1))
            {
               _temp1 = i;
               direction = getDisplayDirection(text.charAt(_temp1));
               i++;
            }
         }
         return direction == 0 ? 1 : direction;
      }
   }
}

