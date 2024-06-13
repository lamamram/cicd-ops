sudo cat <<EOF > /etc/gitlab-runner/config.toml
concurrent = 4
check_interval = 0
connection_max_age = "15m0s"
shutdown_timeout = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "gitlab"
  url = "https://gitlab.myusine.fr/"
  id = 1
  token = "glrt-bn_h2U3NPzB4xiHMnMxg"
  token_obtained_at = 2024-05-27T08:00:44Z
  token_expires_at = 2035-01-01T00:00:00Z
  executor = "docker"
  [runners.custom_build_dir]
  [runners.cache]
    MaxUploadedArchiveSize = 0
    [runners.cache.s3]
    [runners.cache.gcs]
    [runners.cache.azure]
  [runners.docker]
    tls_verify = false
    image = "alpine:latest"
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache", "/etc/gitlab/trusted-certs/gitlab.myusine.fr.crt:/etc/gitlab-runner/certs/ca.crt:ro","/var/run/docker.sock:/var/run/docker.sock"]
    shm_size = 0
    network_mtu = 0
    extra_hosts=["gitlab.myusine.fr:172.17.0.1"]
EOF