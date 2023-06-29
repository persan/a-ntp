--  https://lettier.github.io/posts/2016-04-26-lets-make-a-ntp-client-in-c.html
--  https://www.rfc-editor.org/rfc/rfc5905.txt

with Interfaces;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams;

package NTP is

   type Leap_Indicator is (No_Warning,
                           Last_Minute_Of_The_Day_Has_61_Seconds,
                           Last_Minute_Of_The_Day_Has_59_Seconds,
                           Unknown) with Default_Value => No_Warning;
   --  warning of an impending leap
   --  second to be inserted or deleted in the last minute of the current month

   type Version_Number is range 0 .. 7 with Default_Value => 4;
   --  Representing the NTP Version number

   type Mode_Type is (Reserved,
                      Symmetric_Active,
                      Symmetric_Passive,
                      Client,
                      Server,
                      Broadcast,
                      NTP_Control_Message,
                      Reserved_For_Private_Use);

   type Stratum_Type is range 0 .. 255 with Default_Value => 2;
   subtype Unspecified_Or_Invalid_Stratum is Stratum_Type range 0 .. 0;
   subtype Primary_Server_Stratum is Stratum_Type range 1 .. 1;
   subtype Secondary_Server_Stratum is Stratum_Type range 2 .. 15;
   subtype Unsynchronized_Stratum is Stratum_Type range 16 .. 16;
   subtype Reserved_Stratum is Stratum_Type range 17 .. 255;

   type Poll_Type is range -128 .. 127 with Default_Value => 0;
   type Precision_Type is range -128 .. 127 with Default_Value => 0;

   type NTP_Timestamp is record
      Seconds  :  Interfaces.Unsigned_32;
      Fraction :  Interfaces.Unsigned_32;
   end record with
     Pack => True,
     Size => 64;

   type NTP_Short is  record
      Seconds  :  Interfaces.Unsigned_16;
      Fraction :  Interfaces.Unsigned_16;
   end record with
     Pack => True,
     Size => 32;

   type Ntp_Packet is record
      LI              : Leap_Indicator;
      VN              : Version_Number;
      Mode            : Mode_Type;
      Stratum         : Stratum_Type;
      Poll            : Poll_Type;
      Precision       : Precision_Type;

      Root_Delay      : NTP_Short; -- Total round-trip delay to the reference clock.
      Root_Dispersion : NTP_Short; -- Total dispersion to the reference clock.
      Ref_Id          : Interfaces.Unsigned_32;

      Ref_Tm        : NTP_Timestamp;
      Orig_Tm       : NTP_Timestamp;
      Rx_Tm         : NTP_Timestamp;
      Tx_Tm         : NTP_Timestamp;
   end record with
     Pack => True,
     Size => 384;

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

end NTP;
