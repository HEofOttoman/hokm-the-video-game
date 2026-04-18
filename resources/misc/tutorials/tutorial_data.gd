extends Resource
class_name TutorialStepData

@export var step_name: StringName ## The name of the step
@export var required_event : String ## The name of the signal to trigger this step
@export_multiline() var instructions : String ## The tutorial of the thing
