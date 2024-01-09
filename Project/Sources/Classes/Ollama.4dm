property model : Text
property url : Text

Class constructor($model : Text; $baseURL : Text)
	This:C1470.model:=$model
	This:C1470.timeout:=150
	
	This:C1470.url:=(Count parameters:C259>1) ? $baseURL : "http://localhost:11434"
	If (Length:C16(This:C1470.model)=0)
		This:C1470.model:="llama2"
	End if 
	
	This:C1470._streamDataType:="blob"
	
	//var $4dv:Text
	//$4dv:=Application version
	// if more than 20r4 then _streamDataType:="text"
	
	
Function embedding($prompt : Text) : Object
	var $body; $options : Object
	
	$body:=New object:C1471(\
		"model"; This:C1470.model; \
		"prompt"; $prompt)
	
	$options:=New object:C1471(\
		"method"; "POST"; \
		"body"; $body)
	
	var $request : 4D:C1709.HTTPRequest
	$request:=4D:C1709.HTTPRequest.new(This:C1470.url+"/api/embeddings"; $options)
	
	$request.wait(This:C1470.timeout)
	
	$result:=New object:C1471
	Case of 
		: (Value type:C1509($request.response.body)=Is object:K8:27)
			
			$result:=$request.response.body
			
		: (Value type:C1509($request.response.body)=Is text:K8:3)
			
			$result:=JSON Parse:C1218($request.response.body)  // TODO: check before responsecode and maybe if start with accolade
			
		Else 
			// ASSERT?
	End case 
	
	return $result
	
	
	
Function prompt($prompt : Text; $stream : Boolean)->$result : Object
	
	var $body; $options : Object
	
	$body:=New object:C1471(\
		"model"; This:C1470.model; \
		"prompt"; $prompt; \
		"stream"; Bool:C1537($stream))
	
	
	$options:=New object:C1471(\
		"method"; "POST"; \
		"body"; $body)
	
	If (Bool:C1537($stream))
		// "dataType"; "text"; // not working without my 4d code patch on ndjson
	Else 
		//$options.dataType:="text" or "object"
	End if 
	
	var $request : 4D:C1709.HTTPRequest
	$request:=4D:C1709.HTTPRequest.new(This:C1470.url+"/api/generate"; $options)
	
	$request.wait(This:C1470.timeout)
	
	$result:=New object:C1471("choices"; New collection:C1472)
	
	
	var $text : Text
	Case of 
		: (Value type:C1509($request.response.body)=Is object:K8:27)
			
			If (OB Instance of:C1731($request.response.body; 4D:C1709.Blob))
				
				$result.choices:=JSON Parse:C1218("["+BLOB to text:C555($request.response.body; UTF8 C string:K22:15)+"]")
				
			Else 
				$result:=$request.response.body
			End if 
			
		: (Value type:C1509($request.response.body)=Is text:K8:3)
			
			If (Bool:C1537($stream))
				$result.choices:=JSON Parse:C1218("["+$request.response.body+"]")
			Else 
				$result:=JSON Parse:C1218($request.response.body)
			End if 
	End case 
	
	
	