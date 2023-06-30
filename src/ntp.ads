--  https://lettier.github.io/posts/2016-04-26-lets-make-a-ntp-client-in-c.html
--  https://www.rfc-editor.org/rfc/rfc5905.txt

with Interfaces;

package NTP is

   PORT      : constant := 123;   --  NTP port number
   VERSION   : constant := 4;     --  NTP version number
   TOLERANCE : constant := 15.0e-6; --  frequency tolerance PHI (s/s)
   MINPOLL   : constant := 4;     --  minimum poll exponent (16 s)
   MAXPOLL   : constant := 17;    --  maximum poll exponent (36 h)
   MAXDISP   : constant := 16;    --  maximum dispersion (16 s)
   MINDISP   : constant := 0.005; --  minimum dispersion increment (s)
   MAXDIST   : constant := 1;     --  distance threshold (1 s)
   MAXSTRAT  : constant := 16;    --  maximum stratum numbe

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

   type NTP_Timestamp is private;
   type NTP_Short is private;

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
   end record;



private
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
   for Ntp_Packet use record
      LI              at  0 range  0 ..  1;
      VN              at  0 range  2 ..  4;
      Mode            at  0 range  5 ..  7;
      Stratum         at  1 range  0 ..  7;
      Poll            at  2 range  0 ..  7;
      Precision       at  3 range  0 ..  7;
      Root_Delay      at  4 range  0 .. 31;
      Root_Dispersion at  8 range  0 .. 31;
      Ref_Id          at 12 range  0 .. 31;
      Ref_Tm          at 16 range  0 .. 63;
      Orig_Tm         at 24 range  0 .. 63;
      Rx_Tm           at 32 range  0 .. 63;
      Tx_Tm           at 40 range  0 .. 63;
   end record;

end NTP;
