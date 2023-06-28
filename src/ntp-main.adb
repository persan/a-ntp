procedure NTP.Main is
   S : Server;
   DEFAULT_PORT : constant := 10070;
begin
   S.Initialize (DEFAULT_PORT);
   loop
      S.Serve;
   end loop;
end NTP.Main;
