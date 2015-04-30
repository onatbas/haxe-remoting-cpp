/* AsyncProxy<T> is a class that creates function definitions of T for use in remoting.
In this example ClientApiImpl class is there to provide access to our Client instance in 
client-side through the ClientApi interface. Whatever method is called via this proxy 
will execute in client-side.
*/
class ClientApiImpl extends haxe.remoting.AsyncProxy<ClientApi> {}

/* ClientRepr class represents the clients. For each client a ClientRepr is instantiated.
As it can be seen, this class implements ServerApi, which is the serverside api provided to clients. 
See Server.clientConnection.
*/
class ClientRepr implements ServerApi{
	public var clientApi:ClientApiImpl;
	public var server:Server;


	/* When connection is established and SocketConnection is retrieved, the objects embedded 
	in the context of this connection can be accessed. Assuming client-side configured a ClientApi
	and added it to context with "clientapi" name (as in this codebase), ClientApiImpl can be retrieved
	like so.

	__private field is set for easy access to ClientRepr when client disconnects.
	*/
	public function new(sckt:haxe.remoting.SocketConnection){
		clientApi = new ClientApiImpl(sckt.clientapi);
		(cast sckt).__private = this;
	}

	public function increment():Void {
		server.increment();
	}

	public static function ofConnection( scnx : haxe.remoting.SocketConnection ) : ClientRepr {
		return (cast scnx).__private;
	}
}


class Server {
	
	public static var server:Server;

	public var clients = new List<ClientRepr>();
	public var value:Int = 0;

	public function increment(){
		value++;
		trace("value is " + value);

		for (client in clients){
			client.clientApi.display(value);
		}
	}

	/* A Client representation is created and since it is also the server side api for client, it 
	is added back to context with name "serverapi" to be used in clientside.
	*/
	public function initClientAPI(sckt:haxe.remoting.SocketConnection, cnt:haxe.remoting.Context){
		trace("Client Connected");
		var client = new ClientRepr(sckt);
		clients.push(client);
		client.server = this;
		cnt.addObject("serverapi", client);
	}



	public function clientDisconnected(sckt:haxe.remoting.SocketConnection){
		trace("Client Disconnected");
		clients.remove(ClientRepr.ofConnection(sckt));
	}


	public static function main (){
		server = new Server();
#if cpp
	var serv = new CPPServer(["localhost"]);
#elseif neko
	var serv = new neko.net.ThreadRemotingServer(["localhost"]);
#end
		serv.initClientApi = server.initClientAPI;
		serv.clientDisconnected = server.clientDisconnected;
		serv.run("localhost", 2000);
	}
}