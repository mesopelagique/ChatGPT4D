//%attributes = {}

var $chat : cs:C1710.Ollama
$chat:=cs:C1710.Ollama.new("mistral")

var $prompt : Text
$prompt:=Request:C163("Ask me a question")


If (Length:C16($prompt)=0)
	If (Shift down:C543)
		$prompt:="Why the sky is blue?"
	Else 
		return 
	End if 
End if 

var $result : Object
$result:=$chat.prompt($prompt)

ALERT:C41($result.choices.map(Formula:C1597($1.value.response)).join("\\n"))
