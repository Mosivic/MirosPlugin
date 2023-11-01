extends WeakRef
class_name  GPCJobsSetting


var _layers = []
var _setting := {}


func _init(setting):
	_setting = setting
	for key in _setting.keys():
		var layer = get_job_layer(_setting[key])
		if not _layers.has(layer):
			_layers.append(layer)


func get_setting():
	return _setting


func set_setting(setting):
	_setting = setting


func get_job_seting(job_name):
	if _setting.has(job_name):
		return _setting[job_name]
	else :
		return {}


func get_layers()->Array:
	return _layers



func set_job_setting(job_name,job_setting):
	_setting[job_name] = _setting



func set_jobs_setting(jobs_setting):
	_setting = jobs_setting


static func get_job(st:Dictionary)->GPCJob:
	return GPCJobsTemplate.get_job(get_job_name(st))


static func get_job_name(st:Dictionary):
	var key = 'job'
	if not st.has(key):
		st[key] = 'Idle'
	return st[key]


static func get_job_preconditions(st:Dictionary)->Dictionary:
	var key = 'preconditions'
	if not st.has(key):
		st[key] = {}
	return st[key]


static func get_job_succeed_effects(st:Dictionary)->Dictionary:
	var key = 'succeed_effects'
	if not st.has(key):
		st[key] = {}
	return st[key]


static func get_job_failed_effects(st:Dictionary)->Dictionary:
	var key = 'failed_effects'
	if not st.has(key):
		st[key] = {}
	return st[key]
	
	
static func get_job_failed_conditions(st:Dictionary)->Dictionary:
	var key = 'failed_conditions'
	if not st.has(key):
		st[key] = {}
	return st[key]
	

static func get_job_succeed_conditions(st:Dictionary)->Dictionary:
	var key = 'succeed_conditions'
	if not st.has(key):
		st[key] = {}
	return st[key]



static func get_job_layer(st:Dictionary)->String:
	var key = 'layer'
	if not st.has(key):
		st[key] = 'default'
	return st[key]


static func get_job_cost(st:Dictionary)->int:
	var key = 'cost'
	if not st.has(key):
		st[key] = 0
	return st[key]


static func get_job_priority(st:Dictionary)->int:
	var key = 'priority'
	if not st.has(key):
		st[key] = 0
	return st[key]


static func get_job_misc(st:Dictionary)->Dictionary:
	var key = 'misc'
	if not st.has(key):
		st[key] = {}
	return st[key]


static func get_job_state(st:Dictionary)->int:
	var key = 'state'
	if not st.has(key):
		st[key] = GPC.JobState.RUNNING
	return st[key]


static func get_task_jobs_data(st:Dictionary)->Array:
	var key = 'jobs'
	if not st.has(key):
		st[key] = []
	return st[key]


static func get_task_jobs_size(st:Dictionary)->int:
	return get_task_jobs_data(st).size()


static func get_task_current_job(st:Dictionary)->GPCJob:
	return get_job(get_task_jobs_data(st)[get_task_current_job_index(st)])



static func get_task_current_job_data(st:Dictionary)->Dictionary:
	return get_task_jobs_data(st)[get_task_current_job_index(st)]



static func get_task_current_job_state(st:Dictionary)->int:
	return get_job_state(get_task_current_job_data(st))


static func set_job_state(st:Dictionary,state:int):
	var key = 'state'
	st[key] = state


static func get_task_current_job_index(st:Dictionary)->int:
	var key = 'current_job_index'
	if not st.has(key):
		st[key] = {}
	return st[key]


static func set_task_current_job_index(st:Dictionary,index:int):
	var key = 'current_job_index'
	st[key] = index

