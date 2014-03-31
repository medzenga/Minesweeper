// Minesweeper main class and program starting point
// written by Matt Edzenga

package  {
	
	import flash.display.MovieClip;
	
	import BlockManager;
	import Globals;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	
	import GameStateController;
	
	
	public class MineSweeperMain extends MovieClip			// code starting point; holds instances of various game systems
	{
		private var blockManager:BlockManager = null;
		
		private var remainingMines:RemainingMines = null;
		
		private var gameStateController:GameStateController = null;
		
		public function MineSweeperMain()
		{
			blockManager = new BlockManager(this);
			remainingMines = new RemainingMines();
			gameStateController = new GameStateController(this);
			
			blockManager.Init();
			gameStateController.Init();
			
			gameStateController.SetupMainScreen();
		}
		
		public function getRemainingMinesDisp():RemainingMines
		{
			return remainingMines;
		}
		
		public function getGameStateController():GameStateController
		{
			return gameStateController;
		}
		
		public function getBlockManager():BlockManager
		{
			return blockManager
		}
	}
	
}
