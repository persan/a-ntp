--  https://lettier.github.io/posts/2016-04-26-lets-make-a-ntp-client-in-c.html
--  https://www.rfc-editor.org/rfc/rfc5905.txt

with Interfaces;
with GNAT.Sockets;
with Ada.Streams;

package NTP is
   
   type Leap_Indicator is (No_Warning, 
                           Last_Minute_Of_The_Day_Has_61_Seconds,
                           Last_Minute_Of_The_Day_Has_59_Seconds,
                           Unknown);
   type Version_Number is range 0 .. 7;
   type Mode_Type is (Reserved,
                      Symmetric_Active,
                      Symmetric_Passive,
                      Client,
                      Server,
                      Broadcast,
                      NTP_Control_Message,
                      Reserved_For_Private_Use);
   
   type Stratum_Type is range 0 .. 255;
   subtype Primary_Server_Stratum is Stratum_Type range 1 .. 1;
   subtype Secondary_Server_Stratum is Stratum_Type range 2 .. 15;
   subtype Unsynchronized_Stratum is Stratum_Type range 16 .. 16;
   subtype Reserved_Stratum is Stratum_Type range 17 .. 255;
   type Poll_Type is range -128 .. 127;
   type Precision_Type is range -128 .. 127;
   
   type Ntp_Packet is record
      LI             : Leap_Indicator;
      VN             : Version_Number;
      Mode           : Mode_Type;
      Stratum        : Stratum_Type;
      Poll           : Poll_Type;
      Precision      : Precision_Type;
      RootDelay      : Interfaces.Unsigned_32;
      RootDispersion : Interfaces.Unsigned_32;
      RefId          : Interfaces.Unsigned_32;
      RefTm_S        : Interfaces.Unsigned_32;
      RefTm_F        : Interfaces.Unsigned_32;
      OrigTm_S       : Interfaces.Unsigned_32;
      OrigTm_F       : Interfaces.Unsigned_32;
      RxTm_S         : Interfaces.Unsigned_32;
      RxTm_F         : Interfaces.Unsigned_32;
      TxTm_S         : Interfaces.Unsigned_32;
      TxTm_F         : Interfaces.Unsigned_32;
   end record with
     Pack => True,
     Size => 384;
   
   type Server is tagged private;
   
   procedure Initialize (Self : in out Server; Port : GNAT.Sockets.Port_Number);
   procedure Finalize (Self : in out Server);
   
   procedure On_Call (Self : in out Server;
                      Data  : Ada.Streams.Stream_Element_Array;
                      From   : in GNAT.Sockets.Sock_Addr_Type);
   -- called from serve on on receptio of a valid data package.

   procedure Serve (Self : in out Server);
   -- To be used in busy loop;
private
   type Server is tagged record
      Socket : GNAT.Sockets.Socket_Type;
   end record;

   
end NTP;
