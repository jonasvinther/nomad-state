job "hello_world_v2" {
  ddd
   meta {
    my-key = "my-value"
  }
  
  datacenters = [
  "dc1"
]
  type = "service"

  group "app" {
    count = 2

    network {
      port "http" {
        to = 8001
      }
    }

    
    service {
      name = "webapp"
      tags = [
  "traefik.enable=true",
  "traefik.http.routers.webapp.rule=Path(`/hello`)",
]
      port = "http"

      check {
        name     = "alive"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }


    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "server" {
      driver = "docker"

      config {
        image = "mnomitch/hello_world_server"
        ports = ["http"]
      }

      env {
        MESSAGE = "Hello from Nomad"
      }
    }
  }
}
