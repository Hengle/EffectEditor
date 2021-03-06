package com.yheng.xianyuan.effectEditor.util.effect
{
	import com.codeTooth.actionscript.game.action.ClipsDataManager;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.newUniqueObject.IUniqueObject;
	import com.yheng.xianyuan.effectEditor.core.effectEditor_internal;
	import com.yheng.xianyuan.effectEditor.data.EffectTemplateData;
	import com.yheng.xianyuan.effectEditor.data.StageEffectData;
	
	import flash.utils.ByteArray;

	internal class ActionEffect implements IDestroy, IUniqueObject
	{
		private var _id:Number = 0;
		
		private var _mergeEffectLoader:MergeEffectLoader = null;
		
		private var _completeCallback:Function = null;
		
		private var _clipsDataManager:ClipsDataManager = null;
		
		public function ActionEffect(id:Number, bytes:ByteArray, pCompleteCallback:Function, clipsDataManager:ClipsDataManager)
		{
			_id = id;
			_completeCallback = pCompleteCallback;
			_clipsDataManager = clipsDataManager;
			_mergeEffectLoader = new MergeEffectLoader();
			_mergeEffectLoader.loadBytes(bytes, completeCallback);
		}
		
		public function get id():Number
		{
			return _id;
		}
		
		public function getMergeEffectLoader():MergeEffectLoader
		{
			return _mergeEffectLoader;
		}
		
		private function completeCallback():void
		{
			var stageEffectList:Vector.<StageEffectData> = _mergeEffectLoader.getStageEffectList();
			if(stageEffectList.length > 0)
			{
				var stageEffect:StageEffectData = stageEffectList[0];
				for each(var effectTemplate:EffectTemplateData in stageEffect.effectTemplates)
				{
					_clipsDataManager.createClipsData(effectTemplate.id, effectTemplate.sparrow, effectTemplate.bitmapData);
					effectTemplate.bitmapData.dispose();
					effectTemplate.effectEditor_internal::setBitmapData(null);
				}
			}
			
			_completeCallback();
		}
		
		public function destroy():void
		{
			if(_clipsDataManager != null)
			{
				_clipsDataManager.destroyClipsData(_id);
				_clipsDataManager = null;
			}
			if(_mergeEffectLoader != null)
			{
				_mergeEffectLoader.destroy();
				_mergeEffectLoader = null;
			}
			_completeCallback = null;
			_clipsDataManager = null;
		}
	}
}