extends Node2D
# 文件保存系统测试



# 文件保存系统测试 OK
func saveManagerTest(t:SavaManager):
	#保存数据
	t.SaveData("user://test.txt", "hello world")
	#加载数据并输出
	print(t.LoadData("user://test.txt"))
	# 保存为json
	t.SaveDictAsJson("user://test_json.json", {'name':'test','age':'18'})
	#加载json并输出
	print(t.LoadJsonAsDict("user://test_json.json"))

#声音播放系统测试 OK
func soundManagerTest(t:SoundManager):
	#添加声音
	t.AddSound("牛X哥","res://addons/miros/resource/sound/牛X哥BGM.mp3")
	#播放声音
	t.PlaySound("牛X哥")

