# CHAudioManager

基于AVFoundation.framework封装的音频播放库，对[AFSoundManager]问题修改和重新设计封装的。

##1.基于[AFSoundManager](https://github.com/AlvaroFranco/AFSoundManager)播放代码
在[AFSoundManager](https://github.com/AlvaroFranco/AFSoundManager)播放代码的基础上，修复了原有的代码缺陷，重新设计，增加新的功能

##2.使用
####结构
CHAudioPlayer：音频播放器
CHAudioQueue：音频播放队列
其他分类：工具类
####为播放器提供播放数据
通过CHAudioQueue的audioInfoArr属性 或 CHAudioPlayer的-(void)setAudioInfo:方法为播放器提供播放数据

1. 播放数据可以是一个简单的音频地址
2. 播放数据可以使用自定义的数据model：
3. 播放数据可以使用字典类型的数据

####自定义音频信息
1. 通过自定义的数据model为播放器提供音频数据
通过实现NSObject+CHAudioManager中声明的代理方法CHAudioManagerAudioInfoParse，返回音频信息
2. 可以是字典类型的数据
通过实现调用NSDictionary+CHAudioManager中的-(void)registAudioInfoKeyWithDic:方法，告诉播放器获取音频信息的key；

####后台播放和远程控制
1. 后台播放：
调用-(void)registerBackgroundPlay方法注册后台播放；
在程序的info.plist中增加required background modes项，并将选择值App plays audio or streams audio/video using AirPlay。
2. 远程控制：
调用-(void)registerRemoteEventsWithController:方法注册远程控制的controller；
在注册的controller中实现UIViewController+CHAudioManager的CHAudioManagerRemoteControl协议，处理远程事件的响应方法。


####录音
暂时未加入对录音功能的修改，后面完善一下加上。。。
