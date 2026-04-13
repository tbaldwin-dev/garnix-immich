{ pkgs, ... }:

{
  networking.hostName = "garnix-immich";

  # Enable networking
  networking.useDHCP = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable experimental features
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  # Configure environment variables
  environment.sessionVariables = {
    COLORTERM = "truecolor";
  };

  users.users.admin = {
    isNormalUser = true;
    description = "Admin account";
    shell = pkgs.bash;
    initialPassword = "password";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIDOI82nKBFOu+6kA9RJo4TTOTsYHfKU3+RlUZskl+5f tbaldwin@tarch"
    ];
    extraGroups = [ "wheel" ];
  };

  # Define Immich Service
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 80;
    accelerationDevices = null;
    machine-learning.environment = {
      MACHINE_LEARNING_WORKERS = "1";
      MACHINE_LEARNING_WORKER_TIMEOUT = "120";
      MACHINE_LEARNING_CACHE_FOLDER = "/var/cache/immich";
      IMMICH_HOST = "localhost";
      IMMICH_PORT = "3003";
      HF_XET_CACHE = "/var/cache/immich/huggingface-xet";
    };
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AuthenticationMethods = "publickey";
      PermitRootLogin = "prohibit-password";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
      22
    ];
  };

  system.stateVersion = "25.11";
}
