<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<% String name = request.getParameter("name");
   if (name==null)  name= "무명";
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title>Testing websockets</title>
</head>
<style>
#me, #you {
  
  width:300px;
 
  margin : 10px;
}
#me span{
    background-color: grey;
    bor
    border: 2px solid grey;
  
}
#you span {
   background-color: yellow;
    border: 2px solid grey;
  
}
</style>
<body>
    <fieldset>
        <div id="messageWindow" style="width:500px; height:300px; 
        border: 1px solid grey;  overflow: auto; "></div>
        <br/>
        <input id="inputMessage" type="text"/>
        <input type="submit" value="send" onclick="send()" />
    </fieldset>
</body>
    <script type="text/javascript">
        var textarea = document.getElementById("messageWindow");
        var webSocket = new WebSocket('ws://localhost:9080<%=request.getContextPath()%>/weball');
        var inputMessage = document.getElementById('inputMessage');
    webSocket.onerror = function(event) {
      onError(event)
    };

    webSocket.onopen = function(event) {
      onOpen(event)
    };

    webSocket.onmessage = function(event) {
      onMessage(event)
    };

    function onMessage(event) {
        textarea.innerHTML += "<div  id='you'><span>"+event.data + "</span></div><br>";
        textarea.scrollTop=textarea.scrollHeight;
        
    }

    function onOpen(event) {
            textarea.innerHTML += "연결 성공<br>";
            webSocket.send("<%=name%>:입장 하였습니다");
    }

    function onError(event) {
      alert(event.data);
    }

    function send() {
        textarea.innerHTML += "<div  align='right'  id='me' ><span> 나 : " + inputMessage.value + "<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><br>";
        textarea.scrollTop=textarea.scrollHeight;
        webSocket.send("<%=name%>:"+inputMessage.value);
        inputMessage.value = "";
    }
  </script>
</html>
