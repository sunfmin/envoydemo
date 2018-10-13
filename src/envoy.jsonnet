{
  admin: {
    access_log_path: '/tmp/admin_access.log',
    address: {
      socket_address: {
        address: '0.0.0.0',
        port_value: 9999,
      },
    },
  },
  static_resources: {
    clusters: [
      {
        name: 'testkit',
        connect_timeout: '0.25s',
        type: 'LOGICAL_DNS',
        dns_lookup_family: 'V4_ONLY',
        lb_policy: 'ROUND_ROBIN',
        hosts: [
          {
            socket_address: {
              address: 'testkit',
              port_value: 4000,
            },

          },
        ],
      },
      {
        name: 'testkitv2',
        connect_timeout: '0.25s',
        type: 'LOGICAL_DNS',
        dns_lookup_family: 'V4_ONLY',
        lb_policy: 'ROUND_ROBIN',
        hosts: [
          {
            socket_address: {
              address: 'testkitv2',
              port_value: 4000,
            },
          },
        ],
      },
    ],
    listeners: [
      {
        name: 'baidu',
        address: {
          socket_address: {
            address: '0.0.0.0',
            port_value: 10000,
          },
        },
        filter_chains: [
          {
            filters: [
              {
                name: 'envoy.http_connection_manager',
                config: {
                  stat_prefix: 'the-main-in-traffic',
                  http_filters: [
                    {
                      name: 'envoy.router',
                    },
                  ],
                  route_config: {
                    name: 'local_route',
                    virtual_hosts: [
                      {
                        name: 'local_service',


                        domains: [
                          '*',
                        ],
                        routes: [
                          {
                            match: {
                              prefix: '/redirect',
                            },
                            redirect: {
                              path_redirect: '/redirect_b',
                              strip_query: false,
                            },
                          },
                          {
                            match: {
                              prefix: '/direct',
                            },
                            direct_response: {
                              status: 201,
                              body: {
                                inline_string: 'felix',
                              },
                            },
                          },
                          {
                            match: {
                              prefix: '/testkit',
                              headers: [
                                {
                                  name: 'x-use-version',
                                  exact_match: 'testkitv2',
                                },
                              ],
                            },
                            route: {
                              cluster: 'testkitv2',
                            },
                          },
                          {
                            match: {
                              prefix: '/testkit',
                            },
                            route: {
                              host_rewrite: 'www.testkit.com',
                              cluster: 'testkit',
                            },
                          },
                          {
                            match: {
                              prefix: '/add_header',
                            },
                            request_headers_to_add: [
                              {
                                header: {
                                  key: 'felix-header',
                                  value: '123',
                                },
                                append: false,
                              },
                            ],
                            route: {
                              cluster: 'testkit',
                            },
                          },
                          {
                            match: {
                              prefix: '/append_header',
                            },
                            request_headers_to_add: [
                              {
                                header: {
                                  key: 'User-Agent',
                                  value: 'This is added by felix',
                                },
                                append: true,
                              },
                            ],
                            route: {
                              cluster: 'testkit',
                            },
                            // metadata: {
                            //   region: 'ap-south1',
                            //   zone: 'zone1',
                            //   sub_zone: 'sub_zone1',
                            // },
                          },
                        ],
                      },
                    ],
                  },
                },
              },
            ],
          },
        ],
      },
    ],
  },
}
