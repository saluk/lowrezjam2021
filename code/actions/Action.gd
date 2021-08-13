extends Reference
class_name Action

var method:String
var arguments:Array
var theme:String
var terminus:Action

func _init(method, arguments=[], theme="", terminus=null):
	self.method = method
	self.arguments = arguments
	self.theme = theme
	self.terminus = terminus
