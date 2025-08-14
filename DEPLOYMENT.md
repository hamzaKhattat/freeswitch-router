# FreeSWITCH Router Production Deployment Guide

## System Architecture

```
S1 (Origin) → S2 (Router) → S3 (Intermediate) → S2 (Router) → S4 (Final)
                   ↓
              MySQL/SQLite DB
                   ↓
              UUID Tracking
```

## Key Features

1. **UUID-Based Provider Management**
   - Each provider gets a unique UUID
   - All configurations tracked via UUID
   - JSON mapping files link everything

2. **Automatic XML Generation**
   - No manual FreeSWITCH configuration
   - Gateway, dialplan, ACL files auto-generated
   - Full path tracking in database

3. **DID Pool Management**
   - Dynamic allocation/release
   - Country-based organization
   - Real-time availability tracking

4. **Call Center Ready**
   - High capacity support (thousands of concurrent calls)
   - Rate limiting (CPS control)
   - Complete CDR logging
   - Real-time monitoring

## Installation

```bash
# 1. Install dependencies
apt-get install -y sqlite3 libsqlite3-dev libmicrohttpd-dev \
                   libjson-c-dev uuid-dev libreadline-dev

# 2. Build system
./setup_system.sh

# 3. Configure for production
./demo_call_center.sh

# 4. Start daemon
./router daemon
```

## Provider Configuration

Each provider configuration creates:
- `/opt/freeswitch-router/configs/providers/{UUID}.json` - Complete mapping
- `/usr/local/freeswitch/conf/sip_profiles/external/{UUID}-gateway.xml`
- `/usr/local/freeswitch/conf/dialplan/public/{UUID}-dialplan.xml`
- `/usr/local/freeswitch/conf/autoload_configs/{UUID}-acl.xml` (for IP auth)

## Database Schema

- `providers` - UUID-tracked provider configurations
- `routes` - Three-stage routing rules
- `dids` - DID pool with real-time status
- `cdr` - Complete call records
- `active_calls` - Live call tracking
- `call_stats` - Hourly statistics
- `config_files` - Configuration audit trail

## Monitoring

```bash
# Real-time monitoring
./monitor_system.sh

# Check specific provider
./router provider show <name>

# View routes
./router route list

# DID status
./router did list
```

## API Integration

The system provides HTTP API on port 8083:
- `POST /api/route` - Query routing decisions
- `GET /api/stats` - System statistics
- `GET /api/providers` - Provider list
- `GET /api/calls` - Active calls

## Performance Tuning

For high-volume call centers:

1. Database optimization:
   ```sql
   PRAGMA journal_mode = WAL;
   PRAGMA synchronous = NORMAL;
   PRAGMA cache_size = -64000;
   ```

2. System limits:
   ```bash
   ulimit -n 65536  # File descriptors
   ulimit -u 32768  # Processes
   ```

3. Network tuning:
   ```bash
   sysctl -w net.core.rmem_max=134217728
   sysctl -w net.core.wmem_max=134217728
   ```

## Frontend Integration

Each provider's UUID links to frontend:
1. Read JSON mapping from `/opt/freeswitch-router/configs/providers/{UUID}.json`
2. Access full configuration and paths
3. Real-time status from database
4. Complete audit trail available

## Security

- IP-based authentication with ACLs
- Username/password with SIP registration
- TLS certificate support
- Full audit logging
- Rate limiting per provider

## Troubleshooting

```bash
# Check logs
tail -f logs/router.log

# Verify FreeSWITCH connection
fs_cli -x 'sofia status'

# Database integrity
sqlite3 router.db "PRAGMA integrity_check;"

# Reload configurations
fs_cli -x 'reloadxml'
fs_cli -x 'sofia profile external rescan'
```
