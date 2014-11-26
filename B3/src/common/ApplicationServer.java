package common;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;

public class ApplicationServer {

	public static void main(String[] args) throws Exception {
	    if(args.length != 3) {
	        System.out.println("ApplicactionServer:");
	        System.out.println("   port");
	        System.out.println("   context_path");
	        System.out.println("   base_directory_path");
	        System.exit(1);
	    }
	    
	    int port = Integer.parseInt(args[0]);
	    String contextPath = args[1];
	    String baseDirectoryPath = args[2];
	    
		Server server = new Server(port);
		
		WebAppContext context = new WebAppContext();
		context.setContextPath(contextPath);
		context.setResourceBase(baseDirectoryPath);
		server.setHandler(context);
		
		server.start();
		server.join();
	}

}
