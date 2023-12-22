//%attributes = {}

var $chat : cs:C1710.ChatGPT
$chat:=cs:C1710.ChatGPT.new()
$chat.token:=""  // get it from https://beta.openai.com/account/api-keys

var $prompt : Text
$prompt:=Request:C163("Ask me a question")

If (Length:C16($prompt)=0)
	return 
End if 

var $result : Object
$result:=$chat.prompt($prompt)

ALERT:C41($result.choices.map(Formula:C1597($1.value.text)).join("\\n"))