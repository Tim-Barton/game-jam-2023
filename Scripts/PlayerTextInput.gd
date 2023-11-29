extends TextEdit

@export var lblInstructions : Label
@export var title_node : Control
# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func AlphaNumericOnly(inputStr : String) -> String:
	var subject = inputStr
	var pattern := "[^a-zA-Z0-9 ]"
	var regex := RegEx.new()
	regex.compile(pattern)
	
	var regex_matches := regex.search_all(subject)
	var offset := 0
	for regex_match in regex_matches:
		LevelDirector.DebugMessage(str(regex_match.get_string()))
		subject = subject.replace(regex_match.get_string(),"")
	return subject

func _on_text_changed():
	text = AlphaNumericOnly(self.get_text())
	if self.get_text().length() > 15:
		var inputStr = self.get_text().left(16)
		self.text = inputStr
		self.editable=false
	
	self.text = AlphaNumericOnly(self.get_text())
	self.set_caret_column(16)
	self.set_caret_line(16)
	lblInstructions.visible = false


func _on_gui_input(event):
	if Input.is_action_just_pressed('ui_text_backspace'):
		if self.get_text().length() > 15:
			self.editable = true
			var inputStr = self.get_text().left(16)
			self.text = inputStr
			self.grab_focus()
			self.set_caret_column(16)
			self.set_caret_line(16)
	if Input.is_action_just_pressed('ui_accept'):
		title_node._on_btn_play_pressed()

func _on_btn_clear_name_pressed():
	self.text = ""
