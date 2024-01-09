//%attributes = {}

var $chat : cs:C1710.Ollama
$chat:=cs:C1710.Ollama.new("llama2")
$chat.url:="http://192.168.6.21:11434"

var $prompt : Text
$prompt:=Request:C163("Ask me a question"; "Why the sky is blue?")

If (Length:C16($prompt)=0)
	return 
End if 
If (Not:C34(OK=1))
	return 
End if 

var $result : Object

$result:=$chat.prompt($prompt)

ALERT:C41(String:C10($result.response))
//steam:ALERT($result.choices.map(Formula($1.value.response)).join("\\n"))

$result:=$chat.embedding($prompt)


ALERT:C41(JSON Stringify:C1217($result))
