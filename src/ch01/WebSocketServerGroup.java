package ch01;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/webGroup")
public class WebSocketServerGroup {
	private static Set<Session> clients = Collections
			.synchronizedSet(new HashSet<Session>());

	@OnMessage
	public void onMessage(String message, Session session) throws IOException {
		System.out.println(message);
		synchronized (clients) {
			/*팀별 채팅을 위한 소스
			 * group명:이름:
			 * */
			String id = null;
		    
			String movemessage 
			= session.getRequestParameterMap().get("name") 
			+ ":" + message;
			
			for (Session client : clients) {
		/*cid  : client에서 보내는 group명	
		sid  : 서버가 가지고 있는 session  group명	*/
		String cid = (String)	session.getRequestParameterMap().get("group").get(0);
		String sid = (String)	client.getRequestParameterMap().get("group").get(0);
		
		System.out.println(sid+":"+cid);
				// 자기 자신한테는 보내지 않음
				if (!client.equals(session)) {
		if (cid.equals(sid))			
		client.getBasicRemote().sendText(movemessage);
					
				}

			}
		}
	}

	@OnOpen
	public void onOpen(Session session) {
		System.out.println("onOpen");
		System.out.println(session.getRequestParameterMap());
		// Add session to the connected sessions set
		clients.add(session);
		try {
			onMessage("입장 하였습니다", session);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@OnClose
	public void onClose(Session session) {
		System.out.println("onClose");
		// Remove session from the connected sessions set
		clients.remove(session);
	}
}