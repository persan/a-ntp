procedure NTP.Main is
   S : NTP_Server;
begin
   S.Initialize;
   loop
      S.Serve;
   end loop;
end NTP.Main;
