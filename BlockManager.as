package
{
	import flash.events.KeyboardEvent;
	
	public class BlockManager
	{
		private var BlockMatrix:Array = null;
		
		private var xDim:int;
		private var yDim:int;
		private var totalMines:int;
		
		private var xPositions:Array;
		private var yPositions:Array;
		
		private var mainClass:MineSweeperMain;
		private var gameStateController:GameStateController;
		
		private var ctrlDown:Boolean = false;

		public function BlockManager(mainIn:MineSweeperMain)
		{
			mainClass = mainIn;
			
			mainClass.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			mainClass.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardUp);
		}
		
		public function Init()
		{
			gameStateController = mainClass.getGameStateController();
		}
		
		public function onKeyboardDown(evt:KeyboardEvent)		// used for checking if a ctrl+click is used for flag placement
		{
			if (evt.ctrlKey)
			{
				ctrlDown = true;
			}
		}
		
		public function onKeyboardUp(evt:KeyboardEvent)
		{
			if (evt.ctrlKey == false)
			{
				ctrlDown = false;
			}
		}
		
		public function getMainClass():MineSweeperMain
		{
			return mainClass;
		}
		
		public function getCtrlDown():Boolean
		{
			return ctrlDown;
		}
		
		public function ClearBlockLayout()			// clears all blocks for a new game
		{
			if (BlockMatrix == null)
				return;
				
			for (var i:int=0;i<xDim;i++)
			{
				for (var j:int=0;j<yDim;j++)
				{
					BlockMatrix[i][j].Remove();
				}
			}
			
			BlockMatrix = null;
		}
		
		public function GenerateBlockLayout(xDimIn:int, yDimIn:int, minesIn:int)			// generates the entire block grid for the game based on the difficulty parameters
		{
			xDim = xDimIn;
			yDim = yDimIn;
			totalMines = minesIn;
			
			var i:int = 0;
			
			BlockMatrix = new Array(xDim);
			for (i=0;i<xDim;i++)
				BlockMatrix[i] = new Array(yDim);
			
			xPositions = new Array();
			yPositions = new Array();
			
			var newX:int = 0;
			var newY:int = 0;
			var found:Boolean = false;
			
			for (i=0;i<minesIn;i++)				// generates a set of x/y positions for mine placement
			{
				newX = Math.floor(Math.random() * (xDim));
				newY = Math.floor(Math.random() * (yDim));
				
				found = CheckForMine(newX, newY);
				
				if (found)
				{
					i--;
				}
				else
				{
					xPositions.push(newX);
					yPositions.push(newY);
				}
			}
			
			var nearMines:int = 0;
			var tempX:int = 0;
			var tempY:int = 0;
			
			for (i=0;i<xDim;i++)				// creates 2d grid of mine blocks; also calculates adjacent values for each block to be revealed during gameplay
			{
				for (var j:int=0;j<yDim;j++)
				{
					if (CheckForMine(i,j))
						BlockMatrix[i][j] = new Block(i, j, true, 0, this);
					else
					{
						nearMines = 0;
						
						if (CheckForMine(i-1,j-1)) nearMines++;		// check for surrounding mines and increment counter
						if (CheckForMine(i,j-1)) nearMines++;
						if (CheckForMine(i+1,j-1)) nearMines++;
						if (CheckForMine(i-1,j)) nearMines++;
						if (CheckForMine(i+1,j)) nearMines++;
						if (CheckForMine(i-1,j+1)) nearMines++;
						if (CheckForMine(i,j+1)) nearMines++;
						if (CheckForMine(i+1,j+1)) nearMines++;
						
						BlockMatrix[i][j] = new Block(i, j, false, nearMines, this);
					}
					
					mainClass.addChild(BlockMatrix[i][j]);
					BlockMatrix[i][j].x = 15 + (i*40);
					BlockMatrix[i][j].y = 50 + (j*40);
				}
			}
		}
		
		private function CheckForMine(xIn:int, yIn:int):Boolean			// checks if a mine is at the current location, prevents mine overlap when generating a new grid
		{
			if (xIn < 0 || xIn > xDim)
				return false;
			if (yIn < 0 || yIn > yDim)
				return false;
			
			for (var i:int=0;i<xPositions.length;i++)
			{
				if (xPositions[i] == xIn)
				{
					if (yPositions[i] == yIn)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function CheckForWin():Boolean				// see if the game win requirements have been met
		{
			if (BlockMatrix == null)
				return false;
				
			for (var i:int=0;i<xDim;i++)
			{
				for (var j:int=0;j<yDim;j++)
				{
					if (BlockMatrix[i][j].getIsClicked() == false && BlockMatrix[i][j].getIsMine() == false)
						return false;
				}
			}
			
			gameStateController.GotoWin();
			
			return true;
		}
		
		public function LoseGame()
		{
			gameStateController.GotoLose();
		}
		
		public function ClickSurroundingBlocks(xPos:int, yPos:int)		// used when clicking on a "0" block to recursively autoclick surrounding blocks to save the player time
		{
			AttemptAutoClick(xPos-1, yPos-1);
			AttemptAutoClick(xPos, yPos-1);
			AttemptAutoClick(xPos+1, yPos-1);
			
			AttemptAutoClick(xPos-1, yPos);
			AttemptAutoClick(xPos+1, yPos);
			
			AttemptAutoClick(xPos-1, yPos+1);
			AttemptAutoClick(xPos, yPos+1);
			AttemptAutoClick(xPos+1, yPos+1);
		}
		
		public function AttemptAutoClick(xPos:int, yPos:int)		// does basic commonly used checks to make sure a block isn't out of bounds before sending the click command
		{
			if (xPos < 0 || xPos >= xDim)
				return;
			if (yPos < 0 || yPos >= yDim)
				return;
				
			BlockMatrix[xPos][yPos].DoClick();
		}

	}
	
}
