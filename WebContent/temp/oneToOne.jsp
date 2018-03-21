<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
	<meta charset="UTF-8">
    <title>Testing websockets</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<body>
    <!-- �α����� ������ ���� ��α��� ������ ����� chat_id���� -->
   
        <input type="hidden" value='<%=session.getId().substring(0, 6)%>'
            id='chat_id' />
   
    <!--     ä��â -->
    <div id="_chatbox" style="display: none">
        <fieldset>
            <div id="messageWindow"></div>
            <br /> <input id="inputMessage" type="text" onkeyup="enterkey()" />
            <input type="submit" value="send" onclick="send()" />
        </fieldset>
    </div>
    <img class="chat" src="./img/aaa.gif" />
</body>
<!-- ��ǳ�������� Ŭ���� ä��â ���� �ݱ� -->
<script>
    $(".chat").on({
        "click" : function() {
            if ($(this).attr("src") == "./img/aaa.gif") {
                $(".chat").attr("src", "./img/aaa.gif");
                $("#_chatbox").css("display", "block");
            } else if ($(this).attr("src") == "./img/aaa.gif") {
                $(".chat").attr("src", "./img/aaa.gif");
                $("#_chatbox").css("display", "none");
            }
        }
    });
</script>
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
        var message = event.data.split("|");
        var sender = message[0];
        var content = message[1];
        if (content == "") {
            

        } else {
            if (content.match("/")) {
                if (content.match(("/" + $("#chat_id").val()))) {
                    var temp = content.replace("/" + $("#chat_id").val(), "(�ӼӸ�) :").split(":");
                    if (temp[1].trim() == "") {
                    } else {
                        $("#messageWindow").html($("#messageWindow").html() + "<p class='whisper'>"
                            + sender + content.replace("/" + $("#chat_id").val(), "(�ӼӸ�) :") + "</p>");
                    }
                } else {
                }
            } else {
                if (content.match("!")) {
                    $("#messageWindow").html($("#messageWindow").html()
                        + "<p class='chat_content'><b class='impress'>" + sender + " : " + content + "</b></p>");
                } else {
                    $("#messageWindow").html($("#messageWindow").html()
                        + "<p class='chat_content'>" + sender + " : " + content + "</p>");
                }
            }
        }
    }
    function onOpen(event) {
        $("#messageWindow").html("<p class='chat_content'>ä�ÿ� �����Ͽ����ϴ�.</p>");
    }
    function onError(event) {
        alert(event.data);
    }
    function send() {
        if (inputMessage.value == "") {
        } else {
            $("#messageWindow").html($("#messageWindow").html()
                + "<p class='chat_content'>�� : " + inputMessage.value + "</p>");
        }
        webSocket.send($("#chat_id").val() + "|" + inputMessage.value);
        inputMessage.value = "";
    }
    //     ����Ű�� ���� send��
    function enterkey() {
        if (window.event.keyCode == 13) {
            send();
        }
    }
    //     ä���� ������ ��ũ�ѹٰ� �Ѿ���� �ڵ������� ��ũ�ѹٰ� ����������
    window.setInterval(function() {
        var elem = document.getElementById('messageWindow');
        elem.scrollTop = elem.scrollHeight;
    }, 0);
</script>

