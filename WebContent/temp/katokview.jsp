<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%
	String id = "";
	if (session.getAttribute("id") != null) {
		id = (String) session.getAttribute("id");
	}

	String nick = "";
	if (session.getAttribute("nick") != null) {
		nick = (String) session.getAttribute("nick");
	} else {
		nick = "NICK NULL";
	}
%>


<!-- onkeydown�� ���ؼ� ����Ű�ε� �Էµǵ��� ����. -->
<input id="inputMessage" type="text"
	onkeydown="if(event.keyCode==13){send();}" />
<input type="submit" value="send" onclick="send();" />
<div id="messageWindow2" style="padding:10px 0;height: 20em; overflow: auto; background-color: #a0c0d7;"></div>


<script type="text/javascript">
	
	//������ ����
	    var webSocket = new WebSocket('ws://localhost:9080<%=request.getContextPath()%>/weball');
    
	//var webSocket = new WebSocket('ws://localhost:8080/������Ʈ��/broadcasting');
	var inputMessage = document.getElementById('inputMessage');
	//���� �̰� ������ ������ �̸� �Ǻ��� ����
	var re_send = "";

	webSocket.onerror = function(event) {
		onError(event)
	};
	webSocket.onopen = function(event) {
		onOpen(event)
	};
	webSocket.onmessage = function(event) {
		onMessage(event)
	};

	//	OnClose�� �� ������ ������ �� �����ϴ� �Լ�.
	function onClose(event){
		var div=document.createElement('div');
		
		//�������� �� �����ڵ鿡�� �˸� ����.
		webSocket.send("<%=nick%> is DisConnected\n");
	}

	//	OnMessage�� Ŭ���̾�Ʈ���� ���� ������ �޽����� ������ ȣ��Ǵ� �Լ�.
	function onMessage(event) {

		//Ŭ���̾�Ʈ���� ���ƿ� �޽����� |\| ������ �и��Ѵ�
		var message = event.data.split("|\|");
		
			//�ݹ� ���� �̸� re_send�� �����ϰ�,
			//�ݹ� ���� �̰� �ٽ� ������� ������ ��� ������ ��.
			if(message[0] != re_send){
				//messageWindow2�� ���̱�
				var who = document.createElement('div');

				who.style["padding"]="3px";
				who.style["margin-left"]="3px";

				who.innerHTML = message[0];
				document.getElementById('messageWindow2').appendChild(who);

				re_send = message[0];
			}
		
			//div�� ���� �޽��� ����� ����.
			var div=document.createElement('div');
		
			div.style["width"]="auto";
			div.style["word-wrap"]="break-word";
			div.style["display"]="inline-block";
			div.style["background-color"]="#fcfcfc";
			div.style["border-radius"]="3px";
			div.style["padding"]="13px";
			div.style["margin-left"]="3px";

			div.innerHTML = message[1];
			document.getElementById('messageWindow2').appendChild(div);
		
		//clear div �߰�. �ٹٲ޿�.		
		var clear=document.createElement('div');
		clear.style["clear"]="both";
		document.getElementById('messageWindow2').appendChild(clear);
		
		//div ��ũ�� �Ʒ���.
		messageWindow2.scrollTop = messageWindow2.scrollHeight;
		
	}

	//	OnOpen�� ���� ������ Ŭ���̾�Ʈ�� �� ���� ������ �Ǿ��� �� ȣ��Ǵ� �Լ�.
	function onOpen(event) {
		
		//�������� ��, �� ������ ���̴� ��.
		var div=document.createElement('div');
		
		div.style["text-align"]="center";
		
		div.innerHTML = "�ݰ����ϴ�.";
		document.getElementById('messageWindow2').appendChild(div);
		
		var clear=document.createElement('div');
		clear.style["clear"]="both";
		document.getElementById('messageWindow2').appendChild(clear);
		
		//�������� �� �����ڵ鿡�� �˸� ����.
		webSocket.send("<%=nick%>|\|�ȳ��ϼ���^^");
	}

	//	OnError�� �� ������ ������ ���� �߻��� �ϴ� �Լ�.
	function onError(event) {
		alert("chat_server connecting error " + event.data);
	}
	
	// send �Լ��� ���ؼ� ���������� �޽����� ������.
	function send() {

		//inputMessage�� �������� ���۰���
		if(inputMessage.value!=""){
			
			//	������ ������ ���ư��� ��.
			webSocket.send("<%=nick%>|\|" + inputMessage.value);
			
			// ä��ȭ�� div�� ���� ����
			var div=document.createElement('div');
			
			div.style["width"]="auto";
			div.style["word-wrap"]="break-word";
			div.style["float"]="right";
			div.style["display"]="inline-block";
			div.style["background-color"]="#ffea00";
			div.style["padding"]="13px";
			div.style["border-radius"]="3px";
			div.style["margin-right"]="13px";

			//div�� innerHTML�� ���� �ֱ�
			div.innerHTML = inputMessage.value;
			document.getElementById('messageWindow2').appendChild(div);

			//clear div �߰�
			var clear = document.createElement('div');
			clear.style["clear"] = "both";
			document.getElementById('messageWindow2').appendChild(clear);
			
			//	?
			//inputMessage.value = "";

			//	inputMessage�� value���� �����.
			inputMessage.value = '';

			//	textarea�� ��ũ���� �� ������ ������.
			messageWindow2.scrollTop = messageWindow2.scrollHeight;
			
			//	�ݹ� ���� ����� �ӽ� �����Ѵ�.
			re_send = "<%=nick%>";
		}//inputMessage�� �������� ���۰��� ��.
		
	}
</script>




