package core.utils
{
   import core.locale.LocaleArchive;
   import flash.display.MovieClip;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import skin.Skin;
   
   public class Text
   {
      
      public static var enableTruncationLog:Boolean = false;
      
      public function Text()
      {
         super();
      }
      
      public static function format(_textField:TextField, _composition:*, _truncation:Boolean = true) : void
      {
         if(_textField == null)
         {
            return;
         }
         var _text:String = getText(_composition);
         if(_truncation)
         {
            truncateCharacters(_textField,_text,LocaleArchive.getInstance().isMirrored(),"…",_composition is String);
         }
         else
         {
            _textField.text = _text;
         }
      }
      
      public static function getText(_composition:*) : String
      {
         if(_composition == null)
         {
            return "";
         }
         var _text:String = compose(_composition);
         var _rightToLeft:Boolean = rightToLeft(_text);
         var _multiLine:Boolean = _text.indexOf("\n") != -1;
         if(_multiLine && _rightToLeft)
         {
            _text = rightToLeftMultiLine(_text);
         }
         else if(_rightToLeft)
         {
            _text = ArabicScript.getTransformedString(_text,_rightToLeft);
         }
         return _text;
      }
      
      public static function getBreadcrumb(_breadcrumbs:Array) : String
      {
         var breadcrumb:Object = null;
         if(_breadcrumbs == null)
         {
            return "";
         }
         var _text:String = "";
         var _rightToLeft:Boolean = Boolean(LocaleArchive.getInstance().isMirrored());
         if(Boolean(_breadcrumbs) && _breadcrumbs.length > 0)
         {
            for each(breadcrumb in _breadcrumbs)
            {
               if(_text != "")
               {
                  if(_rightToLeft)
                  {
                     _text = Text.getText(breadcrumb.composition) + " < " + _text;
                  }
                  else
                  {
                     _text += " > " + Text.getText(breadcrumb.composition);
                  }
               }
               else
               {
                  _text = Text.getText(breadcrumb.composition);
               }
            }
         }
         return _text;
      }
      
      public static function formatBreadcrumb(_textField:TextField, _text:String, color:String = "") : void
      {
         if(_textField == null)
         {
            return;
         }
         var _rightToLeft:Boolean = Boolean(LocaleArchive.getInstance().isMirrored());
         var _separator:String = _rightToLeft ? "<" : ">";
         var _highlightFormat:TextFormat = _textField.defaultTextFormat;
         var _start:int = -1;
         var _end:int = -1;
         truncateCharacters(_textField,_text,!_rightToLeft);
         _highlightFormat.color = colorToInt(Skin.style.currentTheme.primaryText.color.hexValue);
         _textField.setTextFormat(_highlightFormat);
         _start = _rightToLeft ? 0 : _textField.text.lastIndexOf(_separator);
         _end = _rightToLeft ? _textField.text.indexOf(_separator) : _textField.text.length;
         _highlightFormat.color = colorToInt(color);
         if(_start != -1 && _end != -1)
         {
            if(!_rightToLeft)
            {
               _start++;
            }
            _textField.setTextFormat(_highlightFormat,_start,_end);
         }
         else
         {
            _textField.setTextFormat(_highlightFormat);
         }
      }
      
      private static function colorToInt(_color:String) : String
      {
         if(_color.charAt(0) == "#")
         {
            return "0x" + _color.substring(1);
         }
         return _color;
      }
      
      private static function rightToLeftMultiLine(_text:String) : String
      {
         var i:int = 0;
         var _lines:Array = _text.split("\n");
         _text = "";
         for(i = 0; i < _lines.length; i++)
         {
            _text += ArabicScript.getTransformedString(_lines[i],true);
            if(i + 1 < _lines.length)
            {
               _text += "\n";
            }
         }
         return _text;
      }
      
      public static function align(_textField:TextField, _align:String = "") : void
      {
         if(_textField == null)
         {
            return;
         }
         if(_align == "")
         {
            _align = LocaleArchive.getInstance().isMirrored() ? TextFormatAlign.RIGHT : TextFormatAlign.LEFT;
         }
         var _textFormat:TextFormat = _textField.getTextFormat();
         _textFormat.align = _align;
         _textField.defaultTextFormat = _textFormat;
         _textField.setTextFormat(_textFormat);
      }
      
      public static function horizontallyAlignChildren(_button:MovieClip, _composition:*) : void
      {
         var _margin:int = 0;
         var _textWidthMax:int = 0;
         if(_button.getChildByName("icon") != null && _button.getChildByName("label") != null)
         {
            _button.label.text = Text.getText(_composition);
            _margin = 5;
            _textWidthMax = _button.width - (_button.icon.width + _margin * 2);
            if(_button.label.textWidth > _textWidthMax)
            {
               _button.icon.x = _margin;
               _button.label.width = _textWidthMax;
               _button.label.x = _button.icon.x + _button.icon.width + _margin;
            }
            else
            {
               _button.label.width = _button.label.textWidth + _margin;
               _button.icon.x = (_button.width - (_button.icon.width + _button.label.width + _margin)) / 2;
               _button.label.x = _button.icon.x + _button.icon.width + _margin;
            }
         }
         else
         {
            trace("<HMICore> [ Text ] Button children not recognized!");
         }
      }
      
      public static function verticallyAlignChildren(_button:MovieClip, _composition:*) : void
      {
         var _margin:int = 4;
         if(_button.getChildByName("label") != null)
         {
            _button.label.text = Text.getText(_composition);
            _button.label.height = _button.label.textHeight + _margin * 2;
            _button.label.y = ((_button.getChildByName("down") != null ? _button.down.height : _button.height) - _button.label.height) / 2;
         }
         else if(_button.getChildByName("value_label") != null)
         {
            _button.value_label.text = Text.getText(_composition);
            _button.value_label.height = _button.value_label.textHeight + _margin * 2;
            _button.value_label.y = ((_button.getChildByName("down") != null ? _button.down.height : _button.height) - _button.value_label.height) / 2;
         }
         else
         {
            trace("<HMICore> [ Text ] Button children not recognized!");
         }
      }
      
      public static function truncateCharacters(_textField:TextField, _text:String, _rightToLeft:Boolean = false, _ellipsis:String = "…", _isDynamic:Boolean = false) : void
      {
         var index:int = 0;
         if(_textField == null)
         {
            return;
         }
         var _padding:int = 4;
         var _truncated:String = _text;
         var _hasTruncation:Boolean = false;
         _textField.text = _text;
         var tfWidth:uint = _textField.width;
         var tfHeight:uint = _textField.height;
         var maxWidth:Number = tfWidth - _padding;
         var maxHeight:Number = tfHeight - _padding;
         var autoSizeSetting:String = _textField.autoSize;
         _textField.autoSize = TextFieldAutoSize.LEFT;
         if(!(_textField.numLines == 1 && _textField.textWidth <= maxWidth || _textField.numLines > 1 && _textField.textHeight <= maxHeight))
         {
            index = -1;
            _hasTruncation = true;
            if(_rightToLeft)
            {
               index = findTruncatedIndexFromRight(_textField,_text,0,_text.length - 1,maxWidth,maxHeight,_ellipsis);
               _textField.text = _ellipsis + _text.substr(index,_text.length - index);
            }
            else
            {
               index = findTruncatedIndexFromLeft(_textField,_text,0,_text.length - 1,maxWidth,maxHeight,_ellipsis);
               _textField.text = _text.substr(0,index) + _ellipsis;
            }
         }
         _textField.autoSize = autoSizeSetting;
         _textField.width = tfWidth;
         _textField.height = tfHeight;
         if(_hasTruncation && !_isDynamic)
         {
            writeDebugLog(_textField);
         }
      }
      
      private static function findTruncatedIndexFromLeft(textField:TextField, text:String, startIndex:int, endIndex:int, maxWidth:int, maxHeight:int, ellipsis:String) : int
      {
         var index:int = 0;
         var str:String = null;
         if(startIndex >= endIndex - 1)
         {
            return startIndex;
         }
         index = startIndex + (endIndex - startIndex) / 2;
         str = text.substr(0,index) + ellipsis;
         textField.text = str;
         if(textField.numLines == 1 && textField.textWidth <= maxWidth || textField.numLines > 1 && textField.textHeight <= maxHeight)
         {
            return findTruncatedIndexFromLeft(textField,text,index,endIndex,maxWidth,maxHeight,ellipsis);
         }
         return findTruncatedIndexFromLeft(textField,text,startIndex,index,maxWidth,maxHeight,ellipsis);
      }
      
      private static function findTruncatedIndexFromRight(textField:TextField, text:String, startIndex:int, endIndex:int, maxWidth:int, maxHeight:int, ellipsis:String) : int
      {
         var index:int = 0;
         var str:String = null;
         if(startIndex >= endIndex - 1)
         {
            return endIndex;
         }
         index = startIndex + (endIndex - startIndex) / 2;
         str = ellipsis + text.substr(index,text.length - index);
         textField.text = str;
         if(textField.numLines == 1 && textField.textWidth <= maxWidth || textField.numLines > 1 && textField.textHeight <= maxHeight)
         {
            return findTruncatedIndexFromRight(textField,text,startIndex,index,maxWidth,maxHeight,ellipsis);
         }
         return findTruncatedIndexFromRight(textField,text,index,endIndex,maxWidth,maxHeight,ellipsis);
      }
      
      public static function rightToLeft(_text:String) : Boolean
      {
         if(ArabicScript.getDetectedDisplayDirection(_text) == -1)
         {
            return true;
         }
         return false;
      }
      
      public static function compose(_composition:*) : String
      {
         var i:int = 0;
         var _tokenValueIndex:int = 0;
         var _text:String = "";
         if(!(_composition is Array))
         {
            if(_composition is uint)
            {
               _text = LocaleArchive.getInstance().getTextByResID(_composition);
            }
            else
            {
               _text = _composition;
            }
         }
         else
         {
            while(i < _composition.length)
            {
               if(_composition[i] is uint)
               {
                  _text += LocaleArchive.getInstance().getTextByResID(_composition[i]);
               }
               else
               {
                  _text += _composition[i];
               }
               _tokenValueIndex = i + 1;
               while(_tokenValueIndex < _composition.length && (_composition[_tokenValueIndex] is String || _composition[_tokenValueIndex] is uint) && _text.indexOf("%s") >= 0)
               {
                  if(_composition[_tokenValueIndex] is String)
                  {
                     _text = _text.replace(/%s/,_composition[_tokenValueIndex]);
                  }
                  else
                  {
                     _text = _text.replace(/%s/,LocaleArchive.getInstance().getTextByResID(_composition[_tokenValueIndex]));
                  }
                  i++;
                  _tokenValueIndex++;
               }
               i++;
            }
         }
         return _text;
      }
      
      public static function colorTag(_textField:TextField, _string:String, _tags:Array) : void
      {
         var tag:Object = null;
         var start:int = 0;
         var end:int = 0;
         var temp:int = 0;
         var newString:String = getText(_string);
         var format:TextFormat = _textField.defaultTextFormat;
         var indexes:Array = new Array();
         var foundTags:Boolean = false;
         for(var i:int = 0; i < _tags.length; i++)
         {
            tag = _tags[i];
            while(newString.indexOf(tag.start) != -1)
            {
               foundTags = true;
               start = getTagSlicedString(newString,tag,_tags).indexOf(tag.start);
               newString = newString.replace(tag.start,"");
               end = getTagSlicedString(newString,tag,_tags).indexOf(tag.end);
               newString = newString.replace(tag.end,"");
               if(start != -1 && end != -1)
               {
                  if(start > end && start > _tags[i].end.length)
                  {
                     temp = start;
                     start = end;
                     end = temp;
                     end -= _tags[i].end.length;
                  }
                  indexes.push([start,end,tag.color]);
               }
            }
         }
         if(foundTags)
         {
            _textField.text = newString;
            while(indexes.length != 0)
            {
               format.color = indexes[0][2];
               if(indexes[0][0] <= indexes[0][1] && indexes[0][0] <= _textField.text.length && indexes[0][1] <= _textField.text.length)
               {
                  _textField.setTextFormat(format,indexes[0][0],indexes[0][1]);
               }
               indexes.shift();
            }
         }
         else
         {
            _textField.text = newString;
         }
         indexes = null;
      }
      
      private static function getTagSlicedString(_string:String, _tag:Object, _tags:Array) : String
      {
         var tag:Object = null;
         var newString:String = _string;
         for(var i:int = 0; i < _tags.length; i++)
         {
            tag = _tags[i];
            if(tag != _tag)
            {
               while(newString.indexOf(tag.start) != -1)
               {
                  newString = newString.replace(tag.start,"");
                  newString = newString.replace(tag.end,"");
               }
            }
         }
         return newString;
      }
      
      public static function timeDelta(_seconds:int) : String
      {
         var string:String = null;
         var seconds:uint = uint(_seconds);
         var minutes:uint = seconds / 60;
         var hours:uint = minutes / 60;
         seconds %= 60;
         minutes %= 60;
         if(hours == 0)
         {
            string = minutes.toString() + ":" + paddedInt(seconds);
         }
         else
         {
            string = hours.toString() + ":" + paddedInt(minutes) + ":" + paddedInt(seconds);
         }
         return string;
      }
      
      public static function paddedInt(_value:int, _padding:uint = 2) : String
      {
         var string:String = null;
         if(_value < 0)
         {
            string = "-" + paddedInt(-_value,_padding);
         }
         else
         {
            string = _value.toString();
            while(string.length < _padding)
            {
               string = "0" + string;
            }
         }
         return string;
      }
      
      public static function resizeToFitByFontSize(_textField:TextField, _padding:Boolean = false, _permanent:Boolean = false) : void
      {
         var flag:Boolean = false;
         var _paddingVal:int = 4;
         var MINIMUM_SIZE:int = 6;
         var format:TextFormat = _textField.getTextFormat();
         var _txtFieldWidth:Number = _padding ? _textField.width - _paddingVal : _textField.width;
         while(_textField.textWidth > _txtFieldWidth && Number(format.size) > MINIMUM_SIZE)
         {
            flag = true;
            format.size = Number(format.size) - 2;
            _textField.y += 1;
            _textField.setTextFormat(format);
         }
         if(_permanent)
         {
            _textField.defaultTextFormat = format;
         }
         if(flag)
         {
            writeDebugLog(_textField);
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
      
      public static function getAvgCharWidth(_textField:TextField, _string:String) : int
      {
         var j:Number = NaN;
         var test:String = null;
         var charWidth:int = 0;
         var arabicCharRanges:Array = [{
            "from":1536,
            "to":1791
         },{
            "from":64336,
            "to":65023
         },{
            "from":65136,
            "to":65279
         }];
         var i:Number = 0;
         var avgCharWidth:int = 0;
         var total:int = 0;
         var k:int = 0;
         while(i < arabicCharRanges.length)
         {
            for(j = Number(arabicCharRanges[i].from); j <= arabicCharRanges[i].to; j++)
            {
               test = String.fromCharCode(j);
               _textField.text = test;
               charWidth = _textField.textWidth;
               total += charWidth;
               _textField.text = "";
               if(charWidth != 0)
               {
                  k++;
               }
            }
            i++;
         }
         return int(total / k);
      }
      
      public static function arabicWordWrap(_textField:TextField, _string:String) : String
      {
         var index:int = 0;
         var maxCharsPerLine:int = _textField.width / 11;
         var test:Array = _string.split("");
         for(var i:int = 0; i < _string.length; i++)
         {
            index = _string.lastIndexOf(" ",i + maxCharsPerLine);
            if(index < _string.length)
            {
               _string = _string.slice(0,index) + "\n" + _string.slice(index,_string.length);
            }
            i = index;
            if(index + maxCharsPerLine > _string.length)
            {
               break;
            }
         }
         var test1:Array = _string.split("");
         return _string;
      }
   }
}

