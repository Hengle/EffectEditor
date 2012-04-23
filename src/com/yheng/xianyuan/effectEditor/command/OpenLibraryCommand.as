package com.yheng.xianyuan.effectEditor.command
{
	import com.codeTooth.actionscript.command.ICommand;
	import com.codeTooth.actionscript.lang.utils.ByteArrayUtil;
	import com.codeTooth.actionscript.lang.utils.FileUtil;
	import com.yheng.xianyuan.effectEditor.persistence.LibraryDeserialise;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	public class OpenLibraryCommand implements ICommand
	{
		public function OpenLibraryCommand()
		{
		}
		
		public function execute(data:Object=null):*
		{
			FileUtil.createFileStatic("openFile", true, selectHandler).browseForOpen("导入特效库");
		}
		
		private function selectHandler():void
		{
			var file:File = FileUtil.getFileStatic("openFile");
			var stream:FileStream = null;
			try
			{
				var buffer:ByteArray = new ByteArray();
				stream = new FileStream();
				stream.open(file, FileMode.READ);
				stream.readBytes(buffer);
				
				if(ByteArrayUtil.checkVerification(buffer, true))
				{
					new LibraryDeserialise().deserialise(buffer);
				}
				else
				{
					Alert.show("无法识别的特效库文件");
				}
			} 
			catch(error:Error) 
			{
				Alert.show(error.message, "无法识别的特效库文件");
			}
			finally
			{
				if(stream != null)
				{
					stream.close();
				}
			}
		}
	}
}