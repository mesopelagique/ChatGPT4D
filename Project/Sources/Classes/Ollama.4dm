property model : Text
property url : Text

Class constructor($model : Text; $baseURL : Text)
	This:C1470.model:=$model
	This:C1470.timeout:=150
	
	This:C1470.url:=(Count parameters:C259>1) ? $baseURL : "http://192.168.6.21:11434"
	If (Length:C16(This:C1470.model)=0)
		This:C1470.model:="llama2"
	End if 
	
	
Function prompt($prompt : Text)->$result : Object
	
	var $body; $options : Object
	
	$body:=New object:C1471(\
		"model"; This:C1470.model; \
		"prompt"; $prompt)
	
	$options:=New object:C1471(\
		"method"; "POST"; \
		"body"; $body)
	
	
	$options.dataType:="text"
	
	
	var $request : 4D:C1709.HTTPRequest
	$request:=4D:C1709.HTTPRequest.new(This:C1470.url+"/api/generate"; $options)
	
	$request.wait(This:C1470.timeout)
	
	$result:=New object:C1471("choices"; New collection:C1472)
	
	
	var $text : Text
	Case of 
		: (Value type:C1509($request.response.body)=Is object:K8:27)
			
			If (OB Instance of:C1731($request.response.body; 4D:C1709.Blob))
				$text:=BLOB to text:C555($request.response.body; UTF8 text without length:K22:17)
			Else 
				ASSERT:C1129(False:C215; JSON Stringify:C1217($request.response.body))
			End if 
			
		: (Value type:C1509($request.response.body)=Is text:K8:3)
			$text:=$request.response.body
	End case 
	
	If (Length:C16($text)>0)
		$result.choices:=JSON Parse:C1218("["+Split string:C1554($text; "\n"; sk ignore empty strings:K86:1).join(",")+"]")
	End if 
	