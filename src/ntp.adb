pragma Ada_2012;
package body NTP is

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Self : in out Server; Port : GNAT.Sockets.Port_Number)
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "Initialize unimplemented");
      raise Program_Error with "Unimplemented procedure Initialize";
   end Initialize;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (Self : in out Server) is
   begin
      pragma Compile_Time_Warning (Standard.True, "Finalize unimplemented");
      raise Program_Error with "Unimplemented procedure Finalize";
   end Finalize;

   -------------
   -- On_Call --
   -------------

   procedure On_Call
     (Self : in out Server; Data : Ada.Streams.Stream_Element_Array;
      From : in     GNAT.Sockets.Sock_Addr_Type)
   is
   begin
      pragma Compile_Time_Warning (Standard.True, "On_Call unimplemented");
      raise Program_Error with "Unimplemented procedure On_Call";
   end On_Call;

   -----------
   -- Serve --
   -----------

   procedure Serve (Self : in out Server) is
      Item   : Ada.Streams.Stream_Element_Array;
      Last   :  Ada.Streams.Stream_Element_Offset;
      From   : GNAT.Sockets.Sock_Addr_Type;
   begin
      Self.Socket.Receive_Socket(
      pragma Compile_Time_Warning (Standard.True, "Serve unimplemented");
      raise Program_Error with "Unimplemented procedure Serve";
   end Serve;

end NTP;
