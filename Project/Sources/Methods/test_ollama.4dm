//%attributes = {}

var $chat : cs:C1710.Ollama
$chat:=cs:C1710.Ollama.new("mistral")

var $prompt : Text
$prompt:=Request:C163("Ask me a question"; "Why the sky is blue?")

If (Length:C16($prompt)=0)
	return 
End if 

If (OK=1)
	
	var $result : Object
	$result:=$chat.prompt($prompt)
	
	ALERT:C41($result.choices.map(Formula:C1597($1.value.response)).join(""))
	
End if 