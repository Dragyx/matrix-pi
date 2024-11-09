{pkgs, ...}: {
  # the docker services

  virtualisation.arion = {
    backend = "docker";
    projects.matrix = {
      serviceName = "matrix";
      settings = {
        services = {
        };
      };
    };
  };
}
