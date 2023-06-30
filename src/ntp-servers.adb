with Ada.Text_IO; use Ada.Text_IO;
with Ada.Streams; use Ada.Streams;
package body NTP.Servers is

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Self    : in out NTP_Server;
                          Port    : GNAT.Sockets.Port_Type := GNAT.Sockets.Port_Number
                            (Get_Service_By_Name ("ntp", "udp")))
   is
      Address : Sock_Addr_Type;
   begin
      Put_Line (Port'Image);
      Create_Socket (Self.Socket, Family_Inet, Socket_Datagram);
      Set_Socket_Option
        (Self.Socket,
         Socket_Level,
         (Reuse_Address, True));

      --  Controls the live time of the datagram to avoid it being
      --  looped forever due to routing errors. Routers decrement
      --  the TTL of every datagram as it traverses from one network
      --  to another and when its value reaches 0 the packet is
      --  dropped. Default is 1.

      Set_Socket_Option
        (Self.Socket,
         IP_Protocol_For_IP_Level,
         (Multicast_TTL, 1));

      --  Want the data you send to be looped back to your host

      Set_Socket_Option
        (Self.Socket,
         IP_Protocol_For_IP_Level,
         (Multicast_Loop, True));
      Address.Addr := Any_Inet_Addr;
      Address.Port := Port;
      Bind_Socket (Self.Socket, Address);
   end Initialize;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (Self : in out NTP_Server) is
   begin
      Close_Socket (Self.Socket);
   end Finalize;

   -------------
   -- On_Call --
   -------------

   procedure On_Call
     (Self : in out NTP_Server;
      Data : Ada.Streams.Stream_Element_Array;
      From : in     GNAT.Sockets.Sock_Addr_Type)
   is
      Data_As_Ntp_Packet : Ntp_Packet with
        Import => True,
        Address => Data'Address;
      Reply_Packet       : Ntp_Packet := Data_As_Ntp_Packet;
      Reply_As_Stream_Element_Array : Stream_Element_Array (1 .. Ntp_Packet'Size / Stream_Element'Size) with
        Import => True,
        Address => Reply_Packet'Address;
   begin
      Put_Line (Data_As_Ntp_Packet'Image);
      Self.Reply (Reply_As_Stream_Element_Array, From);
   end On_Call;

   procedure Reply (Self   : in out NTP_Server;
                    Data   : Ada.Streams.Stream_Element_Array;
                    To     : in GNAT.Sockets.Sock_Addr_Type) is
      Last   : Ada.Streams.Stream_Element_Offset;
   begin
      Send_Socket (Self.Socket, Data, Last, To);
   end;
   -----------
   -- Serve --
   -----------

   procedure Serve (Self : in out NTP_Server) is
      Item   : aliased Ada.Streams.Stream_Element_Array (1 .. 1024);
      Last   : Ada.Streams.Stream_Element_Offset;
      From   : GNAT.Sockets.Sock_Addr_Type;
   begin
      Receive_Socket (Self.Socket, Item, Last, From);
      NTP_Server'Class (Self).On_Call (Item (Item'First .. Last), From);
   end Serve;

end NTP.Servers;
