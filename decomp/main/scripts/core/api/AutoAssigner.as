package core.api
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class AutoAssigner implements IAutoAssigner
   {
      
      private var decorators:Vector.<IDecorator>;
      
      private var semaphoreCount:Number = 0;
      
      private var startTime:Date;
      
      private var endTime:Date;
      
      public function AutoAssigner()
      {
         super();
         this.decorators = new Vector.<IDecorator>();
      }
      
      public function addDecoratorClass(decoratorClass:Class) : Boolean
      {
         var decorator:IDecorator = null;
         try
         {
            decorator = new decoratorClass();
            this.decorators.push(decorator);
         }
         catch(e:Error)
         {
            return false;
         }
         return true;
      }
      
      public function assignChildren(container:DisplayObjectContainer) : void
      {
         var movieClip:MovieClip = null;
         var parsedName:Array = null;
         var decoratorType:String = null;
         if(this.semaphoreCount == 0)
         {
            this.startTime = new Date();
         }
         ++this.semaphoreCount;
         for(var index:int = 0; index < container.numChildren; index++)
         {
            movieClip = container.getChildAt(index) as MovieClip;
            if(movieClip != null)
            {
               parsedName = movieClip.name.split("_");
               if(parsedName.length > 1)
               {
                  decoratorType = parsedName[parsedName.length - 1];
                  if(!movieClip.decoratorType)
                  {
                     this.assignDecorator(movieClip,decoratorType);
                  }
               }
               if(movieClip is DisplayObjectContainer && movieClip.parseChildren == true)
               {
                  this.assignChildren(movieClip as DisplayObjectContainer);
               }
               if(movieClip.update != undefined)
               {
                  movieClip.update();
               }
            }
         }
         --this.semaphoreCount;
         if(this.semaphoreCount == 0)
         {
            this.endTime = new Date();
         }
      }
      
      public function getFunctionDescriptors(displayObject:DisplayObject) : Array
      {
         var movieClip:MovieClip = null;
         var decorator:IDecorator = null;
         if(displayObject is MovieClip)
         {
            movieClip = displayObject as MovieClip;
            if(movieClip.decoratorType)
            {
               for each(decorator in this.decorators)
               {
                  if(decorator.suffix == movieClip.decoratorType)
                  {
                     return decorator.functionDescriptors;
                  }
               }
            }
         }
         return new Array();
      }
      
      public function getFunctionDescriptor(displayObject:DisplayObject, name:String) : Object
      {
         var descriptor:Object = null;
         var descriptors:Array = this.getFunctionDescriptors(displayObject);
         for each(descriptor in descriptors)
         {
            if(descriptor.name == name)
            {
               return descriptor;
            }
         }
         return null;
      }
      
      private function assignDecorator(movieClip:MovieClip, decoratorType:String) : Boolean
      {
         var decorator:IDecorator = null;
         for each(decorator in this.decorators)
         {
            if(decorator.suffix == decoratorType)
            {
               movieClip.decoratorType = decoratorType;
               movieClip.decoration = decorator.decorate(movieClip);
               return true;
            }
         }
         return false;
      }
      
      public function assign(movieClip:MovieClip, decoratorType:String) : void
      {
         trace("<HMICore> [ WARNING AutoAssigner ] Use of depreciated function AutoAssigner.assign() detected.");
         this.assignDecorator(movieClip,decoratorType);
      }
   }
}

