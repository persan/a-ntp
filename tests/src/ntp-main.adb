with NTP.Servers;
procedure NTP.Main is
   S : Servers.NTP_Server;
begin
   S.Initialize;
   loop
      S.Serve;
   end loop;
end NTP.Main;
