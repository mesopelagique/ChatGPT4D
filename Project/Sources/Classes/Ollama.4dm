property model : Text
property url : Text

Class constructor($model : Text; $baseURL : Text)
	This:C1470.model:=$model
	This:C1470.timeout:=150
	
	This:C1470.url:=(Count parameters:C259>1) ? $baseURL : "http://localhost:11434"
	
Function prompt($prompt : Text)->$result : Object
	
	var $body; $options : Object
	
	$body:=New object:C1471(\
		"model"; This:C1470.model; \
		"prompt"; $prompt)
	
	// "dataType"; "text"; // not working
	
	$options:=New object:C1471(\
		"method"; "POST"; \
		"body"; $body)
	
	var $request : 4D:C1709.HTTPRequest
	$request:=4D:C1709.HTTPRequest.new(This:C1470.url+"/api/generate"; $options)
	
	$request.wait(This:C1470.timeout)
	
	$result:=New object:C1471("choices"; New collection:C1472)
	
	
	Case of 
		: (Value type:C1509($request.response.body)=Is object:K8:27)
			
			If (OB Instance of:C1731($request.response.body; 4D:C1709.Blob))
				
				$result.choices:=JSON Parse:C1218("["+BLOB to text:C555($request.response.body; "UTF8")+"]")
				
			Else 
				ASSERT:C1129(False:C215; JSON Stringify:C1217($request.response.body))
			End if 
			
		: (Value type:C1509($request.response.body)=Is text:K8:3)
			$result.choices:=JSON Parse:C1218("["+$request.response.body+"]")
	End case 
	