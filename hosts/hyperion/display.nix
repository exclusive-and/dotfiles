{
  services.xserver = {
    monitorSection = ''
      Option "DPMS" "false"
    '';
    screenSection = ''
      Option "metamodes" "3840x2160_240 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
    '';
    serverLayoutSection = ''
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime"     "0"
    '';
  };
}
