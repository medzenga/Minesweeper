package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	
	public class GameStateController				// this controls the transitions between game states, such as new game, lose, win, main screen
	{
		private var mainClass:MineSweeperMain;
		
		public var EasyButton:SimpleButton;
		public var MediumButton:SimpleButton;
		public var HardButton:SimpleButton;
		
		public var PlayButton:SimpleButton;
		
		private var remainingMines:RemainingMines;
		private var blockManager:BlockManager;

		public function GameStateController(mainClassIn:MineSweeperMain)
		{
			mainClass = mainClassIn;
		}
		
		public function Init()
		{
			remainingMines = mainClass.getRemainingMinesDisp();
			blockManager = mainClass.getBlockManager();
		}
		
		public function SetupMainScreen()			// sets up the main screen so the user can pick a difficulty level
		{
			mainClass.gotoAndStop(1);
			
			EasyButton = mainClass.getChildByName("EasyButton") as SimpleButton;
			if (EasyButton != null)
				EasyButton.addEventListener(MouseEvent.CLICK , EasyClick);
				
			MediumButton = mainClass.getChildByName("MediumButton") as SimpleButton;
			if (MediumButton != null)
				MediumButton.addEventListener(MouseEvent.CLICK , MediumClick);
				
			HardButton = mainClass.getChildByName("HardButton") as SimpleButton;
			if (HardButton != null)
				HardButton.addEventListener(MouseEvent.CLICK , HardClick);
		}
		
		public function EasyClick(evt:Event)			// click callback functions for the above buttons
		{
			StartEasyGame();
		}
		
		public function MediumClick(evt:Event)
		{
			StartMediumGame();
		}
		
		public function HardClick(evt:Event)
		{
			StartHardGame();
		}
		
		public function StartEasyGame()					// separate start game functions incase functionality if added that needs to do these discrete actions without pressing a button
		{
			SetupNewGame(Globals.EasyDimX, Globals.EasyDimY, Globals.EasyMines);
		}
		
		public function StartMediumGame()
		{
			SetupNewGame(Globals.MediumDimX, Globals.MediumDimY, Globals.MediumMines);
		}
		
		public function StartHardGame()
		{
			SetupNewGame(Globals.HardDimX, Globals.HardDimY, Globals.HardMines);
		}
		
		public function SetupNewGame(xIn:int, yIn:int, minesIn:int)			// general new game function used for all difficulty levels, accepts main game parameters
		{
			mainClass.gotoAndStop(2);
			
			var minesDisplay:TextField = mainClass.getChildByName("MinesLeft") as TextField;
			if (remainingMines != null)
				remainingMines.NewGame(minesIn, minesDisplay);
			
			blockManager.GenerateBlockLayout(xIn, yIn, minesIn);
		}
		
		public function GotoWin()					// the player has won, go to the winning screen
		{
			blockManager.ClearBlockLayout();
			mainClass.gotoAndStop(3);
			
			PlayButton = mainClass.getChildByName("PlayButton") as SimpleButton;
			if (PlayButton != null)
				PlayButton.addEventListener(MouseEvent.CLICK , PlayAgain);
		}
		
		public function GotoLose()					// the player has lost, so the losing screen
		{
			blockManager.ClearBlockLayout();
			mainClass.gotoAndStop(4);
			
			PlayButton = mainClass.getChildByName("PlayButton") as SimpleButton;
			if (PlayButton != null)
				PlayButton.addEventListener(MouseEvent.CLICK , PlayAgain);
		}
		
		public function PlayAgain(evt:Event)		// callback for the 'play again' button
		{
			SetupMainScreen();
		}

	}
	
}
