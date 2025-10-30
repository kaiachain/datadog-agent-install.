#!/bin/bash

cat <<EOF>> /etc/datadog-agent/datadog.yaml
hostname: $NODE_NAME
logs_enabled: true

process_config:
  enabled: true

tags:
  - nodetype:$NODE_TYPE
  - instance:$INSTANCE
  - network:$NETWORK

additional_endpoints:
  "https://app.datadoghq.com":
  - $API_KEY

logs_config:
  use_http: true
  additional_endpoints:
  - api_key:  $API_KEY
    Host: "agent-http-intake.logs.datadoghq.com"
    Port: 443
    is_reliable: true


network_devices:
  metadata:
    use_http: true
    additional_endpoints:
    - api_key: $API_KEY
      Host: "https://app.datadoghq.com"
      Port: 443
      is_reliable: true
EOF

cat << EOF > /etc/datadog-agent/conf.d/openmetrics.d/conf.yaml
init_config:

instances:
  - openmetrics_endpoint: http://localhost:61001/metrics
    metrics:
      - klaytn_discover_ping
      - klaytn_discover_pong
      - klaytn_txpool_refuse
      - klaytn_chain_finalize
      - klaytn_rpc_counts_total
      - klaytn_p2p_DialTryCounter
      - klaytn_p2p_InboundTraffic
      - klaytn_p2p_OutboundTraffic
      - klaytn_p2p_CNPeerCountGauge
      - klaytn_p2p_ENPeerCountGauge
      - klaytn_p2p_PNPeerCountGauge
      - klaytn_blockchain_block_tx_counter
      - klaytn_blockchain_head_blocknumber
      - klaytn_klay_prop_blocks_out_traffic
      - klaytn_klay_prop_blocks_in_traffic
      - klaytn_blockchain_bad_block_counter
      - klaytn_consensus_istanbul_core_round
      - klaytn_consensus_istanbul_core_councilSize
      - klaytn_chain_validate
      - klaytn_tx_pool_pending_gauge
      - klaytn_p2p_PeerCountGauge
      - klaytn_consensus_istanbul_core_currentRound
      - klaytn_chain_inserts
      - klaytn_consensus_istanbul_core_timer
      - klaytn_tx_pool_queue_gauge
      - klaytn_klay_db_chaindata_body_disk_read
      - klaytn_klay_db_chaindata_body_disk_write
      - klaytn_klay_prop_txns_in_packets
      - klaytn_klay_prop_txns_in_traffic
      - klaytn_klay_prop_txns_out_packets
      - klaytn_klay_prop_txns_out_traffic
      - klaytn_klay_prop_blocks_in_packets
      - klaytn_klay_prop_blocks_out_packets
      - klaytn_p2p_DialFailCounter
      - klaytn_consensus_istanbul_core_hashLock
      - klaytn_consensus_istanbul_core_committeeSize
      - klaytn_build_info
      - kaiax_auction_bidpool_num_bids
      - kaiax_auction_bidpool_num_bidreqs
      - miner_balance
      
EOF

mkdir -p /etc/datadog-agent/conf.d/go.d
cat << EOF > /etc/datadog-agent/conf.d/go.d/conf.yaml
logs:
  - type: file
    path: $LOG_DIR/kcnd.out
    service: kaia-cn
    source: go
    sourcecategory: sourcecode
EOF

systemctl restart datadog-agent
