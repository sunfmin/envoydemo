{
  scrape_configs: [
    {
      job_name: 'hello',
      metrics_path: '/stats/prometheus',
      scrape_interval: '5s',
      static_configs: [
        {
          targets: [
            'envoy:9999',
          ],

        },
      ],
    },
  ],
}
