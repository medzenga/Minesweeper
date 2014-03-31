package  {
	import flash.text.TextField;
	
	public class RemainingMines
	{
		private var totalMines:int = 0;
		private var placedFlags:int = 0;
		
		private var minesDisplay:TextField;

		public function RemainingMines()
		{
		}
		
		public function NewGame(minesIn:int, displayIn:TextField)		// sets up local variables for a new game
		{
			totalMines = minesIn;
			placedFlags = 0;
			minesDisplay = displayIn;
			updateDisplay();
		}
		
		public function addFlag()			// reducing the amount of mines left on the board by increasing the flag count
		{
			placedFlags++;
			updateDisplay();
		}
		
		public function removeFlag()		// increase mines left by decreasing flag count
		{
			placedFlags--;
			updateDisplay();
		}
		
		public function updateDisplay()		// general display update
		{
			if (minesDisplay == null)
				return;
			
			minesDisplay.text = (totalMines - placedFlags).toString();
		}

	}
	
}
