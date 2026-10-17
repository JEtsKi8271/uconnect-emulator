package ancillary
{
   import core.locale.LocaleArchive;
   import core.utils.Text;
   import flash.display.MovieClip;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import locale.T;
   
   public class Format
   {
      
      public static var HighlightTruncations:Boolean = false;
      
      public static var ShowTRs:Boolean = false;
      
      public static var ShowTRBounds:Boolean = false;
      
      public static var enableTruncationLog:Boolean = false;
      
      public function Format()
      {
         super();
      }
      
      public static function phoneNumber(number:String) : String
      {
         var formattedNumber:String = "";
         for(var i:int = 0; i < number.length; i++)
         {
            switch(number.charAt(i))
            {
               case "0":
               case "1":
               case "2":
               case "3":
               case "4":
               case "5":
               case "6":
               case "7":
               case "8":
               case "9":
               case "-":
               case "+":
                  break;
               default:
                  return number;
            }
         }
         var pattern:RegExp = /-/g;
         number = number.replace(pattern,"");
         if(number.charAt(0) == "+")
         {
            formattedNumber += "+";
            number = number.slice(1);
         }
         switch(number.length)
         {
            case 11:
               if(number.charAt(0) == "1")
               {
                  if(Global.market == "North America")
                  {
                     formattedNumber += "1-";
                  }
                  else
                  {
                     formattedNumber += "1";
                  }
                  number = number.slice(1);
               }
            case 10:
               if(Global.market == "North America")
               {
                  formattedNumber += number.slice(0,3) + "-";
               }
               else
               {
                  formattedNumber += number.slice(0,3);
               }
               number = number.slice(3);
            case 7:
               if(Global.market == "North America")
               {
                  formattedNumber += number.slice(0,3) + "-";
               }
               else
               {
                  formattedNumber += number.slice(0,3);
               }
               formattedNumber += number.slice(3);
               break;
            default:
               if(number.length > 11)
               {
                  if(Global.market == "North America")
                  {
                     formattedNumber += number.slice(0,number.length - 10) + "-";
                     number = number.slice(number.length - 10);
                     formattedNumber += number.slice(0,3) + "-";
                     number = number.slice(3);
                     formattedNumber += number.slice(0,3) + "-";
                     number = number.slice(3);
                  }
               }
               formattedNumber += number;
         }
         return formattedNumber;
      }
      
      public static function dateFormat(date:String) : String
      {
         var formattedDate:String = null;
         var tempArray:Array = date.split("-");
         if(tempArray.length == 3)
         {
            formattedDate = tempArray[1] + "/" + tempArray[2] + "/" + tempArray[0];
         }
         else
         {
            formattedDate = date;
         }
         return formattedDate;
      }
      
      public static function timeOfDay(time:String) : String
      {
         var formattedTime:String = null;
         var am:Boolean = false;
         var tempArray:Array = time.split(":");
         if(tempArray.length == 3)
         {
            switch(tempArray[0])
            {
               case "00":
                  tempArray[0] = "12";
                  am = true;
                  break;
               case "12":
                  am = false;
                  break;
               case "01":
                  tempArray[0] = "1";
                  am = true;
                  break;
               case "02":
                  tempArray[0] = "2";
                  am = true;
                  break;
               case "03":
                  tempArray[0] = "3";
                  am = true;
                  break;
               case "04":
                  tempArray[0] = "4";
                  am = true;
                  break;
               case "05":
                  tempArray[0] = "5";
                  am = true;
                  break;
               case "06":
                  tempArray[0] = "6";
                  am = true;
                  break;
               case "07":
                  tempArray[0] = "7";
                  am = true;
                  break;
               case "08":
                  tempArray[0] = "8";
                  am = true;
                  break;
               case "09":
                  tempArray[0] = "9";
                  am = true;
                  break;
               case "13":
                  tempArray[0] = "1";
                  break;
               case "14":
                  tempArray[0] = "2";
                  break;
               case "15":
                  tempArray[0] = "3";
                  break;
               case "16":
                  tempArray[0] = "4";
                  break;
               case "17":
                  tempArray[0] = "5";
                  break;
               case "18":
                  tempArray[0] = "6";
                  break;
               case "19":
                  tempArray[0] = "7";
                  break;
               case "20":
                  tempArray[0] = "8";
                  break;
               case "21":
                  tempArray[0] = "9";
                  break;
               case "22":
                  tempArray[0] = "10";
                  break;
               case "23":
                  tempArray[0] = "11";
                  break;
               default:
                  am = true;
            }
            formattedTime = tempArray[0] + ":" + tempArray[1] + (am ? " am" : " pm");
         }
         else
         {
            formattedTime = time;
         }
         return formattedTime;
      }
      
      public static function htmlBreadcrumb(title:String, color:String = "", separator:String = ">", htmlSeparator:String = "&gt;") : String
      {
         var titleArray:Array = title.split(separator);
         var formattedTitle:String = "";
         if(color == "")
         {
            color = Style.BREADCRUMB_HIGHLIGHT_COLOR;
         }
         for(var i:int = 0; i < titleArray.length - 1; i++)
         {
            formattedTitle += titleArray[i] + separator;
         }
         return formattedTitle + ("<FONT COLOR=\"" + color + "\" >" + titleArray[titleArray.length - 1] + "</FONT>");
      }
      
      public static function htmlColor(text:String, color:String) : String
      {
         return "<FONT COLOR=\"" + color + "\" >" + text + "</FONT>";
      }
      
      public static function date(date:Date) : String
      {
         var year:String = date.getFullYear().toString();
         year = year.substr(year.length - 2);
         return date.getMonth().toString() + "/" + date.getDate().toString() + "/" + year;
      }
      
      public static function nameCase(name:String, wordSeparator:String = " ") : String
      {
         var piece:String = null;
         var index:int = 0;
         var pieces:Array = name.split(wordSeparator);
         var output:Array = new Array();
         for each(piece in pieces)
         {
            if(piece == "RD")
            {
               piece = "Rd";
            }
            else if(piece == "ST")
            {
               piece = "St";
            }
            else if(piece == "BLVD")
            {
               piece = "Blvd";
            }
            else if(piece == "DRV")
            {
               piece = "Drv";
            }
            else if(piece == "LN")
            {
               piece = "Ln";
            }
            else if(piece == "TRL")
            {
               piece = "Trl";
            }
            else if(piece.search(/(a|e|i|o|u|y|A|E|I|O|U|Y)/) >= 0)
            {
               piece = charToUpperCase(piece.toLowerCase());
               index = piece.indexOf("-");
               if(index >= 0)
               {
                  piece = charToUpperCase(piece,index + 1);
               }
            }
            else
            {
               piece.toUpperCase();
            }
            output.push(piece);
         }
         return output.join(wordSeparator);
      }
      
      private static function charToUpperCase(string:String, index:int = 0) : String
      {
         var head:String = string.substring(0,index);
         var middle:String = string.charAt(index);
         var tail:String = string.substr(index + 1);
         return head + middle.toUpperCase() + tail;
      }
      
      public static function timeDelta(ms:int) : String
      {
         var string:String = null;
         var s:uint = ms / 1000;
         var min:uint = s / 60;
         var h:uint = min / 60;
         s %= 60;
         min %= 60;
         string = paddedInt(s);
         if(h == 0)
         {
            string = min.toString() + ":" + string;
         }
         else
         {
            string = h.toString() + ":" + paddedInt(min) + ":" + string;
         }
         return string;
      }
      
      public static function paddedInt(value:int, padding:uint = 2) : String
      {
         var string:String = null;
         if(value < 0)
         {
            string = "-" + paddedInt(-value,padding);
         }
         else
         {
            string = value.toString();
            while(string.length < padding)
            {
               string = "0" + string;
            }
         }
         return string;
      }
      
      public static function itemsInList(value:int) : Array
      {
         if(value == 1)
         {
            return [value.toString() + " ",T.STRB_ITEM_IN_LIST];
         }
         return [value.toString() + " ",T.STRB_ITEMS_IN_LIST];
      }
      
      public static function applyBreadcrumb(textField:TextField, breadcrumb:String, color:String = "", separator:String = ">") : void
      {
         textField.text = breadcrumb;
         if(!color)
         {
            color = Style.BREADCRUMB_HIGHLIGHT_COLOR;
         }
         var _breadcrumb:String = breadcrumb;
         while(textField.numLines == 1 && textField.textWidth > textField.width - 4 || textField.numLines > 1 && textField.textHeight > textField.height - 4)
         {
            _breadcrumb = _breadcrumb.substring(2,_breadcrumb.length);
            textField.text = "…" + _breadcrumb;
         }
         var end:int = textField.text.length;
         var start:int = textField.text.lastIndexOf(separator);
         var highlightFormat:TextFormat = textField.defaultTextFormat;
         highlightFormat.color = colorToInt(color);
         if(start != -1)
         {
            textField.setTextFormat(highlightFormat,start + 1,end);
         }
         else
         {
            textField.setTextFormat(highlightFormat);
         }
      }
      
      public static function colorToInt(color:String) : String
      {
         if(color.charAt(0) == "#")
         {
            return "0x" + color.substring(1);
         }
         return color;
      }
      
      public static function autoScale(text:TextField, size:Number = 34) : void
      {
         var resize:TextFormat = new TextFormat();
         resize.size = size;
         text.setTextFormat(resize);
         while(text.textWidth > text.width - 5 || text.textHeight > text.height && size > 0)
         {
            size--;
            resize.size = size;
            text.setTextFormat(resize);
         }
      }
      
      public static function truncateCharacters(textField:TextField, text:String, ellipsis:String = "…", isDynamic:Boolean = false) : void
      {
         Text.format(textField,text,true);
      }
      
      public static function truncateCharactersForMediaBrowse(textField:TextField) : void
      {
         var txt:String = null;
         if(textField == null)
         {
            return;
         }
         txt = textField.text;
         if(txt.length > 48)
         {
            txt = txt.slice(0,48);
         }
         truncateCharacters(textField,textField.text,"…",true);
      }
      
      public static function truncateWords(textField:TextField, text:String, ellipsis:String = "…", isDyanmic:Boolean = false) : void
      {
         textField.text = text;
         var hasTruncations:Boolean = false;
         highlightTruncations(textField);
         showTR(textField);
         showTRBounds(textField);
         while(textField.numLines == 1 && textField.textWidth > textField.width - 4 || textField.numLines > 1 && textField.textHeight > textField.height - 4)
         {
            text = text.substring(0,text.lastIndexOf(" "));
            if(text.indexOf(" ") < 0)
            {
               truncateCharacters(textField,textField.text,ellipsis,isDyanmic);
               return;
            }
            textField.text = text + ellipsis;
            hasTruncations = true;
         }
      }
      
      public static function highlightTruncations(_textField:TextField) : void
      {
         if(HighlightTruncations)
         {
            if(_textField.width < _textField.textWidth)
            {
               _textField.opaqueBackground = 15602158;
            }
            else if(_textField.height + 15 < _textField.textHeight)
            {
               _textField.opaqueBackground = 16755200;
            }
            else
            {
               _textField.opaqueBackground = null;
            }
         }
         else if(_textField.opaqueBackground == 15602158 || _textField.opaqueBackground == 16755200)
         {
            _textField.opaqueBackground = null;
         }
      }
      
      public static function showTR(_textField:TextField) : void
      {
         var numLines:Number = NaN;
         if(ShowTRs)
         {
            numLines = 1;
            if(_textField.numLines > 1)
            {
               numLines = _textField.numLines;
            }
            _textField.text = _textField.width.toString().split(".")[0] + "_" + _textField.htmlText.substr(_textField.htmlText.search("SIZE=") + 6,2);
            if(numLines > 1)
            {
               _textField.text = _textField.text + "_" + numLines.toString();
            }
         }
      }
      
      public static function showTRBounds(_textField:TextField) : void
      {
         if(ShowTRBounds)
         {
            _textField.border = true;
            _textField.borderColor = 16777215;
         }
         else if(_textField.border)
         {
            _textField.border = false;
         }
      }
      
      public static function htmlPath(path:String, char:String = ">", align:String = "LEFT") : String
      {
         var words:Array = path.split(char);
         var title:String = "<P ALIGN=\"" + align + "\">";
         for(var i:int = 0; i < words.length - 1; i++)
         {
            title += words[i] + char;
         }
         return title + ("<FONT COLOR=\"" + Style.BREADCRUMB_HIGHLIGHT_COLOR + "\" >" + words[words.length - 1] + "</FONT></P>");
      }
      
      public static function getTextWidth(textField:TextField, text:String) : int
      {
         textField.text = text;
         return int(textField.textWidth);
      }
      
      public static function dynamicTruncate(textField:TextField, dyna:String, fixed:String, ellipsis:String = "…") : void
      {
         var color:String = Style.BREADCRUMB_HIGHLIGHT_COLOR;
         var untouched:Boolean = true;
         var truncated:String = dyna;
         var flexibleWidth:int = textField.width - getTextWidth(textField," " + fixed + " ");
         textField.text = truncated;
         while(textField.textWidth > flexibleWidth)
         {
            untouched = false;
            truncated = truncated.substring(0,truncated.length - 1);
            textField.text = truncated + ellipsis;
         }
         if(untouched)
         {
            textField.text = truncated + " " + fixed;
         }
         else
         {
            textField.text = truncated + ellipsis + " " + fixed;
         }
         var highlightFormat:TextFormat = textField.defaultTextFormat;
         highlightFormat.color = colorToInt(color);
         var end:int = textField.text.length;
         var start:int = end - fixed.length;
         if(start != end)
         {
            textField.setTextFormat(highlightFormat,start,end);
         }
      }
      
      public static function colorize(textField:TextField, text:String, color:String = "") : void
      {
         if(!color)
         {
            color = Style.BREADCRUMB_HIGHLIGHT_COLOR;
         }
         var highlightFormat:TextFormat = textField.defaultTextFormat;
         textField.text = text;
         highlightFormat.color = colorToInt(color);
         var end:int = textField.text.length;
         var start:int = end - text.length;
         if(start != end)
         {
            textField.setTextFormat(highlightFormat,start,end);
         }
      }
      
      public static function outline(field:TextField) : void
      {
         var mTextOutline:GlowFilter = new GlowFilter(0,1,2,2,10);
         field.filters = [mTextOutline];
      }
      
      public static function dropShadow(field:TextField) : void
      {
         var mDropShadow:DropShadowFilter = new DropShadowFilter(3,45,0.8,4,4);
         field.filters = [mDropShadow];
      }
      
      public static function setFormat(textField:TextField, text:String, align:String, bold:Boolean) : void
      {
         var mFormat:TextFormat = new TextFormat();
         mFormat.align = align;
         mFormat.bold = bold;
         truncateCharacters(textField,text);
         textField.setTextFormat(mFormat);
      }
      
      public static function fahrenheitToCelsius(fahrenheit:Number) : Number
      {
         return (fahrenheit - 32) * 5 / 9;
      }
      
      public static function celsiusToFahrenheit(celsius:Number) : Number
      {
         return 32 + celsius * 9 / 5;
      }
      
      public static function colorSubstring(_textField:TextField, _colorString:String, _color:String) : void
      {
         var fullString:String = null;
         var colorString:String = null;
         var color:String = null;
         var format:TextFormat = null;
         var start:int = 0;
         if(_colorString != "")
         {
            fullString = _textField.text;
            colorString = _colorString;
            color = Format.colorToInt(_color);
            format = _textField.defaultTextFormat;
            start = fullString.indexOf(_colorString);
            if(start != -1)
            {
               format.color = color;
               _textField.setTextFormat(format,start,start + _colorString.length);
            }
         }
      }
      
      public static function underline(_line:MovieClip, _textfield:TextField, _subString:String, _padding:int = 2) : void
      {
         var index:int = 0;
         var unaltered:String = _textfield.text;
         var sub:String = _subString;
         var fullWidth:Number = _textfield.textWidth;
         var startPoint:Number = 0;
         var endPoint:Number = 0;
         if(LocaleArchive.getInstance().isMirrored())
         {
            index = unaltered.toLowerCase().lastIndexOf(_subString.toLowerCase());
            if(index != -1)
            {
               _textfield.text = unaltered.substr(0,index + sub.length);
               startPoint = _textfield.textWidth;
               _textfield.text = unaltered.substr(0,index);
               endPoint = _textfield.textWidth;
               _line.width = startPoint - endPoint;
               _line.x = _textfield.x + _textfield.width - (_padding + _line.width + fullWidth - startPoint);
               _textfield.text = unaltered;
               _line.visible = true;
            }
         }
         else
         {
            index = unaltered.toLowerCase().indexOf(_subString.toLowerCase());
            if(index != -1)
            {
               _textfield.text = unaltered.substr(0,index);
               startPoint = _textfield.textWidth;
               _textfield.text = unaltered.substr(0,index + sub.length);
               endPoint = _textfield.textWidth;
               _line.x = startPoint + _textfield.x + _padding;
               _line.width = endPoint - startPoint;
               _textfield.text = unaltered;
               _line.visible = true;
            }
         }
      }
      
      private static function writeDebugLog(_textField:TextField) : void
      {
         var outString:String;
         var parentObject:Object;
         var file:File;
         var outStream:FileStream;
         if(!enableTruncationLog)
         {
            return;
         }
         outString = "/" + _textField.name + " ----Text_Contents: " + _textField.text + "----TextField_Width: " + _textField.width.toString() + "px ----TextField_Height: " + _textField.height.toString() + "px ----Font_Size: " + _textField.getTextFormat().size + " ----Multiline: " + (_textField.multiline ? "true: " + _textField.numLines.toString() + " Lines" : "false");
         parentObject = _textField;
         while(parentObject.hasOwnProperty("parent") && parentObject["parent"] != null)
         {
            outString = "/" + parentObject.toString() + outString;
            parentObject = parentObject["parent"];
         }
         outString = "----" + outString + "\r\n \r\n";
         file = new File("file:///usr/var/truncationLog.txt");
         outStream = new FileStream();
         try
         {
            outStream.open(file,FileMode.APPEND);
            outStream.writeUTFBytes(outString);
            outStream.close();
         }
         catch(err:Error)
         {
         }
      }
   }
}

