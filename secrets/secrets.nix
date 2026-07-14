with import ./keys/public.nix;
{
  "hyperion/wireguard.privatekey.age" = {
    publicKeys = [hyperion];
  };
}
