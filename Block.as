package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Block extends MovieClip
	{
		private var isMine:Boolean;
		private var numDisp:int;
		
		private var isFlagged:Boolean = false;
		private var isClicked:Boolean = false;
		
		private var blockDisplay:BlockDisplay = null;
		
		private var blockMng:BlockManager;
		private var mainScript:MineSweeperMain = null;
		private var remainingMines:RemainingMines = null;
		
		private var xPos:int = 0;
		private var yPos:int = 0;

		public function Block(xPosIn:int, yPosIn:int, isMineIn:Boolean, numDispIn:int, managerIn:BlockManager)
		{
			xPos = xPosIn;
			yPos = yPosIn;
			
			isMine = isMineIn;
			numDisp = numDispIn;
			blockMng = managerIn;
			if (blockMng != null)
				mainScript = blockMng.getMainClass();
			if (mainScript != null)
				remainingMines = mainScript.getRemainingMinesDisp();
			
			blockDisplay = new BlockDisplay(this);
			
			this.addEventListener(MouseEvent.CLICK , ClickCallback);
		}
		
		public function ClickCallback(evt:Event)
		{
			DoClick();
		}
		
		public function DoClick():Boolean
		{
			if (isClicked)
				return true;
				
			if (blockMng.getCtrlDown())
			{
				ToggleFlag();
				return true;
			}
			
			if (isFlagged)
				return true;
				
			isClicked = true;
			
			if (isMine)
			{
				blockDisplay.Explode();
				blockMng.LoseGame();
				return false;
			}
			
			blockDisplay.MarkOkay(numDisp);
			blockMng.CheckForWin();
			
			if (numDisp == 0)
				blockMng.ClickSurroundingBlocks(xPos,yPos);
			
			return true;
		}
		
		public function ToggleFlag()
		{
			if (isClicked)
				return;
				
			if (isFlagged)
				isFlagged = false;
			else
				isFlagged = true;
				
			blockDisplay.SetFlagged(isFlagged);
			
			if (remainingMines != null)
			{
				if (isFlagged)
					remainingMines.addFlag();
				else
					remainingMines.removeFlag();
			}
		}
		
		public function getIsMine():Boolean
		{
			return isMine;
		}
		
		public function getNumDisp():int
		{
			return numDisp;
		}
		
		public function getIsClicked():Boolean
		{
			return isClicked;
		}
		
		public function Remove()
		{
			blockDisplay.Remove();
		}

	}
	
}
