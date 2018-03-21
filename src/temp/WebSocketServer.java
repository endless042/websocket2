package temp;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/weballtemp")
public class WebSocketServer {

	private static Set<Session> clients = Collections
			.synchronizedSet(new HashSet<Session>());

	@OnMessage
	public void onMessage(String message, Session session) throws IOException {
		
		System.out.println(message);
		synchronized (clients) {
			// Iterate over the connected sessions
			// and broadcast the received message
			String id = null;
			System.out.println("==========="+message);
			//===========admin:/1fkdsjflkdfds message 내용임
			//  이름:메세지 내용임 
			if(message.indexOf(":[")>0) {
				id=message.substring(message.indexOf(":["), 1);
				System.out.println("id:"+id);
			}
			String movemessage = session.getId()+":"+message;
			for (Session client : clients) {
				if (!client.equals(session)) {
					client.getBasicRemote().sendText(movemessage);
				}
			}
		}
	}

	
	@OnOpen
	public void onOpen(Session session) {
		// Add session to the connected sessions set
	
		clients.add(session);
	}
	@OnClose
	public void onClose(Session session) {
		// Remove session from the connected sessions set
		clients.remove(session);
	}
}
