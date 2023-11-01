extends WeakRef
class_name GPCJobsTemplate

static  var _jobs_template = {
	Idle = preload("res://addons/miros/module/GpcAI/custom/jobs/Idle.gd").new(),
	Walk = preload("res://addons/miros/module/GpcAI/custom/jobs/Walk.gd").new(),
	Run = preload("res://addons/miros/module/GpcAI/custom/jobs/Run.gd").new(),
	Attack = preload("res://addons/miros/module/GpcAI/custom/jobs/Attack.gd").new(),
	BeHit = preload("res://addons/miros/module/GpcAI/custom/jobs/BeHit.gd").new(),
	Say = preload("res://addons/miros/module/GpcAI/custom/jobs/Say.gd").new(),
	TaskSerial = preload("res://addons/miros/module/GpcAI/src/base/task_serial.gd").new(),
#	TaskAll = preload("res://addons/miros/module/GpcAI/src/base/task_all.gd").new(),
#	TaskSelect = preload("res://addons/miros/module/GpcAI/src/base/task_select.gd").new(),
}

static func get_job(job_name):
	return _jobs_template[job_name]
