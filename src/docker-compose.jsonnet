{
  version: '3',
  services: {
    envoy: {
      image: 'envoyproxy/envoy-alpine:latest',
      volumes: [
        './envoy.yaml:/etc/envoy/envoy.yaml',
      ],
      ports: [
        '10000:10000',
        '9999:9999',
      ],
      environment: [
        'loglevel=debug',
      ],
    },
    testkit: {
      image: 'sunfmin/testkit',
      ports: [
        '4000:4000',
      ],
    },
    prometheus: {
      image: 'quay.io/prometheus/prometheus',
      ports: [
        '9090:9090',
      ],
      volumes: [
        './prometheus.yml:/etc/prometheus/prometheus.yml',
      ],
    },
    grafana: {
      image: 'grafana/grafana',
      ports: [
        '3000:3000',
      ],
    },
  },
}
