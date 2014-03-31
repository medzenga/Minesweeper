package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import Block;
	
	public class BlockDisplay					// separate display class for blocks that can be swapped out for other display methods if needed
	{											// also allows for easy separation of workload so that graphics could be worked on separately without affecting the core game logic
		private var BaseClass:Block = null;

		public function BlockDisplay(baseIn:Block)
		{
			BaseClass = baseIn;
		}
		
		public function SetFlagged(flag:Boolean)		// changes the flag graphics of the current block
		{
			if (flag)
				BaseClass.gotoAndStop(2);
			else
				BaseClass.gotoAndStop(1);
		}
		
		public function Explode()				// changes the explode graphics of the current block
		{
			BaseClass.gotoAndStop(4);
		}
		
		public function MarkOkay(adjacentMinesVal:int)		// marks the current block as okay and reveals the number of surrounding mines (or blank for 0 to clean up the board)
		{
			BaseClass.gotoAndStop(3);
			var adjcentDisp:TextField = BaseClass.getChildByName("adjacentMines") as TextField;
			if (adjcentDisp != null)
			{
				if (adjacentMinesVal > 0)
					adjcentDisp.text = adjacentMinesVal.toString();
				else
					adjcentDisp.text = "";
			}
		}
		
		public function Remove()							// removes associated graphics for the current block, generally used when the block is about to be destroyed
		{
			BaseClass.parent.removeChild(BaseClass);
		}

	}
	
}
