extends Resource
class_name EmailResource

@export_group("Sender Info")
@export var sender_name: String = "Tech Support"
@export var sender_email: String = "support@real-company.com"

@export_group("Content")
@export var subject: String = "Urgent: Password Reset"
@export_multiline var body_text: String = "We detected a suspicious login. Click here to secure your account."

@export_group("Security Logic")
@export var is_phishing: bool = false
@export var real_url_hint: String = "https://safe-login.com"
@export_multiline var educational_tip: String = "This email is safe because the domain matches our official site."
