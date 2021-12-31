#####################################
# 时间轴工具 - 用于指定函数在某时刻运行
# ver0.1
#####################################
extends Node
enum EXECUTE_TYPE{NULL,SHOT,LOOP}
class_name Timeline

var timeline:Array = []
var time:float = 0
var index = 0
var functions:Array 


#func _ready():
#	add_time_stamp(4,funcref(self,"test"),["我是你爹"])
#	add_time_stamp(3,funcref(self,"test"),["我是你爷"])
#	add_time_stamp(6,funcref(self,"test"),["我是你哥"])
#	add_time_stamp(2,funcref(self,"test"),["我是你弟"])
#	add_time_stamp(2,funcref(self,"test2"))
#

func _process(delta):
	execute_ready(delta)
	execute()

func test(extra):
	print("NowTime:"+str(time)+str(extra))
	
func test2():
	print("我要飞我要飞!")
	
# 遍历Timeline,将以可执行函数加入执行函数表
func execute_ready(delta):
	if not timeline.size()>index: return
	time += delta
	if time >= timeline[index]["stamp"]:
		functions.append(timeline[index])
		index += 1

# 根据不同类型执行函数
func execute():
	for function in functions:
		if function["type"] == EXECUTE_TYPE.SHOT:
			function["func"].call_funcv(function["args"])
			functions.erase(function)
			continue
		elif function["type"] == EXECUTE_TYPE.LOOP:
			function["func"].call_funcv(function["args"])
		else:
			continue
		
# 加入时间戳到时间轴
func add_time_stamp(stamp:float,function:FuncRef,args:Array=[],type=1):
	var t = {"stamp":stamp,"func":function,"args":args,"type":type}
	var size = timeline.size()
	#时间戳正序插入
	if size == 0:
		timeline.append(t)
	else:
		if stamp >= timeline[size-1]["stamp"]:
			timeline.append(t)
		else:
			var i = size-1
			while(1):
				if stamp >= timeline[i]["stamp"] or i==0:
					timeline.insert(i,t)
					break
				else:
					i-=1
					


