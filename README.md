# ChatGPT4D

Simple call to ChatGPT API using `4D.HTTPRequest`

## Usage

You need an API Key, by loging to openai and get one here https://beta.openai.com/account/api-keys

```4d
$chat:=cs.ChatGPT.new()
$chat.token:="xxx"  // get it from https://beta.openai.com/account/api-keys

$result:=$chat.prompt($prompt)

$allMessages=$result.choices.map(Formula($1.value.text)).join("\n"))
```

see [test.4dm](Project/Sources/Methods/test.4dm) for a full example

For instance I ask if ChatGTP know the 4D Language (to code for me)

<img width="480" alt="ChatGTPAbout4D" src="https://user-images.githubusercontent.com/59135882/208221693-5748f2a7-98c0-471c-89f5-f3a7111aa2b0.png">
