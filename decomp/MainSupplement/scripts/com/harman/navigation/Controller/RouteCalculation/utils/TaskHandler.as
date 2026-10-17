package com.harman.navigation.Controller.RouteCalculation.utils
{
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculation;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.nfuzion.framework.global.Framework;
   
   public class TaskHandler
   {
      
      private var mTaskQueue:Array = new Array();
      
      private var mRouteCalculation:RouteCalculation;
      
      public function TaskHandler(rc:RouteCalculation)
      {
         super();
         this.mRouteCalculation = rc;
      }
      
      public function addTask(task:RC_Task) : void
      {
         Framework.Trace("RouteCalculation.TaskHandler.addTask(" + task.myTaskTypeString + ") q:" + this.mTaskQueue.length);
         for(var i:int = 0; i < this.mTaskQueue.length; i++)
         {
            Framework.Trace(i + ": " + RC_Task(this.mTaskQueue[i]).myTaskTypeString);
         }
         this.mTaskQueue.push(task);
         this.filterObsoleteTasks();
         if(this.mTaskQueue.length == 1)
         {
            this.processNextTask();
         }
      }
      
      public function reportTaskCompletion(taskType:int) : void
      {
         var id:int = 0;
         if(this.mTaskQueue.length <= 0)
         {
            Framework.Trace("RouteCalculation.TaskHandler.reportTaskCompletion( " + taskType + " ) Queue=" + this.mTaskQueue.length);
            return;
         }
         if(taskType == RC_Task(this.mTaskQueue[0]).taskType)
         {
            id = int(RC_Task(this.mTaskQueue[0]).ID);
            this.mTaskQueue.splice(0,1);
            this.mRouteCalculation.sendEvent(RouteCalculationEvent.TASK_COMPLETION,null,id);
            this.processNextTask();
         }
         else
         {
            this.mRouteCalculation.sendEvent(RouteCalculationEvent.TASK_COMPLETION);
            Framework.Trace("RouteCalculation.TaskHandler.reportTaskCompletion() unexpected task completed: " + taskType + " expected:" + RC_Task(this.mTaskQueue[0]).taskType);
         }
      }
      
      public function get activeTaskID() : uint
      {
         if(this.mTaskQueue.length >= 1)
         {
            return RC_Task(this.mTaskQueue[0]).ID;
         }
         return 0;
      }
      
      public function get activeTaskType() : int
      {
         if(this.mTaskQueue.length >= 1)
         {
            return RC_Task(this.mTaskQueue[0]).taskType;
         }
         return -1;
      }
      
      public function isActiveTaskOfTaskType(taskType:int) : Boolean
      {
         if(this.mTaskQueue.length >= 1)
         {
            if(taskType == RC_Task(this.mTaskQueue[0]).taskType)
            {
               return true;
            }
         }
         return false;
      }
      
      public function clearQueueStack(taskID:int) : void
      {
         if(this.mTaskQueue.length > 0)
         {
            if(taskID == RC_Task(this.mTaskQueue[0]).ID)
            {
               this.mTaskQueue.pop();
            }
         }
      }
      
      private function filterObsoleteTasks() : void
      {
      }
      
      private function processNextTask() : void
      {
         if(this.mTaskQueue.length >= 1)
         {
            this.printTaskQueue();
            RC_Task(this.mTaskQueue[0]).processTask();
         }
         else
         {
            Framework.Trace("RouteCalculation.TaskHandler.processNextTask() Queue empty");
         }
      }
      
      private function printTaskQueue() : void
      {
         var output:String = "RouteCalculation.TaskHandler.Queue(" + this.mTaskQueue.length + "):";
         for(var i:int = 0; i < this.mTaskQueue.length; i++)
         {
            output += " " + RC_Task.getString(RC_Task(this.mTaskQueue[i]).taskType);
         }
         Framework.Trace(output);
      }
   }
}

