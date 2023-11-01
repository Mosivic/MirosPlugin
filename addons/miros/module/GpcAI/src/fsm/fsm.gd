# 动作机
# 2023.10.24_ver_1.0
#
# 使用：
# 1.创建ActionMachine节点（脚本继承GPCActionMachine），
# 2.在ActionMachine节点创建Action节点（脚本继承job），编写动作脚本
# 3.在ActionMachine节点该节点内，在_init虚函数内实例化jobs_setting（GPCActionsSetting）
#	为动作机指定动作配置，配置使用Action节点名为Key，该Action节点才能生效。
#
# 配置机制：
# _layer : 动作层次，字符串，在同一层次只中动作机中只能存在一种动作。
# _priority : 优先级，整数，在预选动作中优先级最高的作为下一个执行动作。
#
# _begin_conditions ：开始执行条件，字典，只有满足该条件动作才能作为预选动作。
# _continue_conditions :继续执行条件，字典，只有满足该条件动作才能继续执行。
#
# _succeed_effects ：成功效果，字典，当动作执行成功时设置PropertySensor相应变量。
# _faild_effects ： 失败效果，字典，当动作执行失败时设置PropertySensor相应变量。
# _interrupted_effects ： 中断效果，字典，当动作执行中断时设置PropertySensor相应变量。


extends Node
class_name  GPCFSM


var _jobs_execute := {}
var _custom_jobs_data : Dictionary


@export var property_sensor:GPCPropertySensor
@export var actor:Node

var _jobs_setting:GPCJobsSetting 



func _ready() -> void:
	if property_sensor == null:
		print("property sensor is null")
		return
		
	if actor == null:
		print("actor is null")
		return
	
	await actor.ready  #wait actor'children ready
	
	# init property
	property_sensor.set_actor(actor)

	_custom_jobs_data = _jobs_setting.get_setting()


	for layer in _jobs_setting.get_layers():
		_jobs_execute[layer] = {}


func _process(delta: float) -> void:
	_update_job()
	
	for job_data in _jobs_execute.values():
		if not job_data.is_empty():
			GPCJobsSetting.get_job(job_data).execute(delta,false,job_data,property_sensor)


func _physics_process(delta: float) -> void:
	for job_data in _jobs_execute.values():
		if not job_data.is_empty():
			GPCJobsSetting.get_job(job_data).execute(delta,true,job_data,property_sensor)


# update _acrion_execute
func _update_job():
	for layer in _jobs_execute.keys():
		var current_job_data = _jobs_execute[layer]
		
		if current_job_data.is_empty():
			var next_job_data = _get_best_job_data(layer)
			
			if not next_job_data.is_empty():
				_jobs_execute[layer] = next_job_data
				GPCJobsSetting.get_job(_jobs_execute[layer]).enter(_jobs_execute[layer],property_sensor)
				
		else:
			var state = GPCJobsSetting.get_job_state(current_job_data)
			
			if state != GPC.JobState.RUNNING:
				var next_job_data = _get_best_job_data(layer)
				
				if next_job_data.is_empty():
					GPCJobsSetting.get_job(_jobs_execute[layer]).exit(_jobs_execute[layer],property_sensor)
					_jobs_execute[layer] = {}
				else:
					GPCJobsSetting.get_job(_jobs_execute[layer]).exit(_jobs_execute[layer],property_sensor)
					_jobs_execute[layer] = next_job_data
					GPCJobsSetting.get_job(_jobs_execute[layer]).enter(_jobs_execute[layer],property_sensor)


func _get_best_job_data(layer:String):
	var candicate_jobs_data := []
	
	for key in _custom_jobs_data.keys():
		var job = GPCJobsSetting.get_job(_custom_jobs_data[key])
		var c_layer= GPCJobsSetting.get_job_layer(_custom_jobs_data[key])
		if c_layer == layer and job.can_execute(_custom_jobs_data[key],property_sensor):
			candicate_jobs_data.append(_custom_jobs_data[key])
	
	if candicate_jobs_data.size() == 0:
		return {}
	else:
		return _get_higest_priorty_job_data(candicate_jobs_data)


# 获取最合适的Job
# 参数jobs不能为空
func _get_higest_priorty_job_data(jobs_data:Array):
	var best_job_data = jobs_data[0]
	for  data in jobs_data:
		if GPCJobsSetting.get_job_priority(data) > GPCJobsSetting.get_job_priority(best_job_data):
			best_job_data = data
	
	return best_job_data


