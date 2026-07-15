{
  services.xserver = {
    monitorSection = ''
      Option "DPMS" "false"
    '';
    screenSection = ''
      Option "metamodes" "2560x1600_165 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
    '';
    serverLayoutSection = ''
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime"     "0"
    '';
  };
}
