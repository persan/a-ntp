--  https://lettier.github.io/posts/2016-04-26-lets-make-a-ntp-client-in-c.html
--  https://www.rfc-editor.org/rfc/rfc5905.txt
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams;

package NTP.Servers is

   type NTP_Server is tagged private;

   procedure Initialize (Self : in out NTP_Server;
                         Port : GNAT.Sockets.Port_Type := GNAT.Sockets.Port_Number
                           (Get_Service_By_Name ("ntp", "udp")));

   procedure Finalize (Self : in out NTP_Server);

   procedure On_Call (Self   : in out NTP_Server;
                      Data   : Ada.Streams.Stream_Element_Array;
                      From   : in GNAT.Sockets.Sock_Addr_Type);
   --  called from serve on on receptio of a valid data package.
   procedure Reply (Self   : in out NTP_Server;
                    Data   : Ada.Streams.Stream_Element_Array;
                    To     : in GNAT.Sockets.Sock_Addr_Type);
   procedure Serve (Self : in out NTP_Server);
   --  To be used in busy loop;

private
   type NTP_Server is tagged record
      Socket : GNAT.Sockets.Socket_Type;
   end record;

end NTP.Servers;
