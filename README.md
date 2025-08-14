# FreeSWITCH Router

A high-performance call routing system for FreeSWITCH written in C, replacing the original Asterisk ARA Router.

## Features

- Dynamic call routing with provider management
- DID pool allocation and management
- Load balancing strategies
- Real-time health monitoring
- Call verification and security
- PostgreSQL database backend
- Redis caching support
- FreeSWITCH ESL integration
- RESTful HTTP API
- Comprehensive logging

## Architecture

The system follows the same call flow as the original:
1. S1 (Inbound) → S2 (Router) → S3 (Intermediate)
2. S3 → S2 (Return with transformed ANI)
3. S2 → S4 (Final destination)

## Building

### Prerequisites

```bash
# Ubuntu/Debian
sudo apt-get install cmake libpq-dev libhiredis-dev libjansson-dev libevent-dev libcheck-dev

# CentOS/RHEL
sudo yum install cmake postgresql-devel hiredis-devel jansson-devel libevent-devel check-devel
```

### Build Steps

```bash
./build.sh
```

Or manually:

```bash
mkdir build
cd build
cmake ..
make
make test
```

## Installation

1. Create the database:
```bash
createdb freeswitch_router
psql freeswitch_router < scripts/schema.sql
```

2. Configure the application:
```bash
cp configs/config.json configs/config.json.bak
# Edit configs/config.json with your settings
```

3. Run the router:
```bash
./build/freeswitch_router -c configs/config.json
```

## Configuration

The configuration file supports the following sections:

- `database`: PostgreSQL connection settings
- `redis`: Redis cache settings  
- `esl`: FreeSWITCH Event Socket Library settings
- `server`: HTTP API server settings
- `router`: Core routing configuration
- `logging`: Logging configuration

## API Endpoints

- `POST /api/v1/process/incoming` - Process incoming call from S1
- `POST /api/v1/process/return` - Process return call from S3
- `POST /api/v1/process/final` - Process final call from S4
- `GET /api/v1/stats` - Get system statistics
- `GET /health` - Health check endpoint

## FreeSWITCH Integration

### HTTP API Integration

Create a dialplan extension in FreeSWITCH:

```xml
<extension name="route_incoming">
  <condition field="destination_number" expression="^(\d+)$">
    <action application="set" data="call_id=${uuid}"/>
    <action application="curl" data="http://localhost:8080/api/v1/process/incoming json {call_id: '${call_id}', ani: '${caller_id_number}', dnis: '$1', provider: '${sip_from_host}'}"/>
    
    <condition field="${router_status}" expression="^success$">
      <action application="set" data="effective_caller_id_number=${ani_to_send}"/>
      <action application="bridge" data="sofia/external/${dnis_to_send}@${next_hop}"/>
      <anti-action application="hangup" data="CALL_REJECTED"/>
    </condition>
  </condition>
</extension>
```

### ESL Integration (Optional)

If ESL library is available, the router can process events directly from FreeSWITCH.

## Database Schema

The router uses PostgreSQL with the following main tables:

- `providers`: SIP provider configurations
- `dids`: DID pool management
- `provider_routes`: Routing configurations
- `call_records`: Call detail records
- `provider_health`: Health monitoring data

## Systemd Service

To install as a system service:

```bash
sudo cp scripts/freeswitch-router.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable freeswitch-router
sudo systemctl start freeswitch-router
```

## API Examples

### Process Incoming Call

```bash
curl -X POST http://localhost:8080/api/v1/process/incoming \
  -H "Content-Type: application/json" \
  -d '{
    "call_id": "550e8400-e29b-41d4-a716-446655440000",
    "ani": "+1234567890",
    "dnis": "+0987654321",
    "provider": "provider-s1"
  }'
```

Response:
```json
{
  "status": "success",
  "did_assigned": "1000",
  "next_hop": "10.0.0.3:5060",
  "ani_to_send": "+0987654321",
  "dnis_to_send": "1000"
}
```

### Process Return Call

```bash
curl -X POST http://localhost:8080/api/v1/process/return \
  -H "Content-Type: application/json" \
  -d '{
    "ani2": "+1234567890", 
    "did": "1000",
    "provider": "provider-s3",
    "source_ip": "10.0.0.3"
  }'
```

### Get Statistics

```bash
curl http://localhost:8080/api/v1/stats
```

## Development

### Running Tests

```bash
cd build
make test
```

### Debug Mode

```bash
./build/freeswitch_router -c configs/config.json -v
```

## License

[Your License Here]

## Contributing

[Contributing Guidelines]
# freeswitch-router
# freeswitch-router
