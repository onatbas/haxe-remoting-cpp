/* AsyncProxy<T> is a class that creates function definitions of T for use in remoting.
In this example ServerApiImpl class is there to provide access to our Server instance in 
server-side through the ServerApi interface. Whatever method is called via this proxy 
will execute in server-side.
*/
class ServerApiImpl extends haxe.remoting.AsyncProxy<ServerApi>{}

/* This is the class whom methods server has access to.
*/
class Client implements ClientApi{
	public var serverapi:ServerApiImpl;


	/* As it can be seen, instance of this class is passed to context to be shared with server-side,
	where it is retrieved with name "clientapi".
	Also Server side api is retrieved in the constructor with name "serverapi".
	*/
	public function new (){
#if (cpp)
		var socket = new sys.net.Socket();
		socket.connect(new sys.net.Host("http://localhost"), 2000);
#elseif (flash) 
		var socket = new flash.net.XMLSocket();
		socket.connect("localhost",2000);
#end
		var context = new haxe.remoting.Context();
		context.addObject("clientapi", this);
		
		var connection = haxe.remoting.SocketConnection.create(socket, context);
		serverapi = new ServerApiImpl(connection.serverapi);
		serverapi.increment();
	}

	public function display(value:Int){
		trace("Value is incremented to " + value);
	}

	public static function main(){
		var client = new Client();
	}
}