extends Resource
class_name MessageResource

@export_group("Message Info")
@export var title: String = "Unknown Sender"
@export var description: String = "Hey, check this out!"
@export var date: String = "Today 14:32"

@export_group("Security Logic")
@export var is_phishing: bool = false
@export_multiline var educational_tip: String = "This message is safe because it comes from a trusted source and shows no signs of phishing."
@export var difficulty: int = 1
