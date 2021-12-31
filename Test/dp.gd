tool
extends Node2D


var script_count = 0 setget set_script_count


var __script_list = []
var __script_data = {}


func set_script_count(value):
	
	
	# script_count 值跟上次相差多少
	var diff = value - script_count

	# 超过上次的值，则增加属性
	if diff > 0:
		var property = ""
		for i in diff:
			# 属性名为 script + 动态的属性的个数
			property = "script_" + str(__script_list.size())

			__script_list.push_back({
				name = property,	# 属性名
				type = TYPE_OBJECT,	# 属性是个对象
				hint = PROPERTY_HINT_RESOURCE_TYPE,	# 资源
				hint_string = "GDScript",	# 类型为 GDScript
			})

	# 比上次的小，则减少属性
	elif diff < 0:
		var idx = -1
		for i in abs(diff):
			idx = __script_list.size() - 1
			__script_list.remove(idx);

	script_count = value

	# 更新属性表
	property_list_changed_notify()


func _get_property_list():
	# 属性列表
	var p_list = []
	# 属性类别
	p_list.append({
		name = "Script List",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY,
	})
	# 属性：脚本数量
	p_list.append({
		name = "script_count",
		type = TYPE_INT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0, 10, 1, or_greater"
	})
	# 属性：脚本列表
	p_list.append({
		name="_list",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP,
	})
	p_list.append_array(__script_list)

	return p_list


func _set(property, value):
	# 记录属性数据
	__script_data[property] = value


func _get(property):
	# 返回属性数据
	if __script_data.has(property):
		return __script_data[property] 
