Class constructor
	This:C1470.model:="text-davinci-003"
	This:C1470.max_tokens:=4000  // The maximum number of tokens to generate in the completion.
	This:C1470.temperature:=1  // What sampling temperature to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.
	
	
Function prompt($prompt : Text)->$result : Object
	If (Not:C34(Asserted:C1132(Length:C16(String:C10(This:C1470.token))>0; "You must defined your api key by affecting `token`property")))
		return 
	End if 
	
	var $headers; $body; $options : Object
	$headers:=New object:C1471(\
		"Content-Type"; "application/json"; \
		"Authorization"; "Bearer "+String:C10(This:C1470.token))
	
	$body:=New object:C1471(\
		"model"; This:C1470.model; \
		"prompt"; $prompt; \
		"max_tokens"; This:C1470.max_tokens; \
		"temperature"; This:C1470.temperature)
	
	$options:=New object:C1471(\
		"method"; "POST"; \
		"headers"; $headers; \
		"body"; $body)
	
	var $request : 4D:C1709.HTTPRequest
	$request:=4D:C1709.HTTPRequest.new("https://api.openai.com/v1/completions"; $options)
	
	$request.wait()
	
	$result:=$request.response
	If (Num:C11($request.response.status)=200)
		$result:=$result.body
	End if 