// This example is from the book _Java in a Nutshell_ by David Flanagan.
// Written by David Flanagan.  Copyright (c) 1996 O'Reilly & Associates.
// You may study, use, modify, and distribute this example for any purpose.
// This example is provided WITHOUT WARRANTY either expressed or implied.

import java.io.*;
import java.net.*;

public class Client {
    public static final int DEFAULT_PORT = 6789;
    public static void usage() {
        System.out.println("Usage: java Client <hostname> [<port>]");
        System.exit(0);
    }    
    public static void main(String[] args) {
        int port = DEFAULT_PORT;
        Socket s = null;
        
        // Parse the port specification
        if ((args.length != 1) && (args.length != 2)) usage();
        if (args.length == 1) port = DEFAULT_PORT;
        else {
            try { port = Integer.parseInt(args[1]); }
            catch (NumberFormatException e) { usage(); }
        }
        
        try {
            // Create a socket to communicate to the specified host and port
            s = new Socket(args[0], port);
            // Create streams for reading and writing lines of text
            // from and to this socket.
            DataInputStream sin = new DataInputStream(s.getInputStream());
            PrintStream sout = new PrintStream(s.getOutputStream());
            // Create a stream for reading lines of text from the console
            DataInputStream in = new DataInputStream(System.in);
            
            // Tell the user that we've connected
            System.out.println("Connected to " + s.getInetAddress()
                       + ":"+ s.getPort());

            String line;
            while(true) {
                // print a prompt
                System.out.print("> "); 
                System.out.flush();
                // read a line from the console; check for EOF
                line = in.readLine();
                if (line == null) break;
                // Send it to the server
                sout.println(line);
                // Read a line from the server.  
                line = sin.readLine();
                // Check if connection is closed (i.e. for EOF)
                if (line == null) { 
                    System.out.println("Connection closed by server.");
                    break;
                }
                // And write the line to the console.
                System.out.println(line);
            }
        }
        catch (IOException e) { System.err.println(e); }
        // Always be sure to close the socket
        finally {
            try { if (s != null) s.close(); } catch (IOException e2) { ; }
        }
    }
}