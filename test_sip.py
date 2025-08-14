#!/usr/bin/env python3
"""
SIP Test Script for FreeSWITCH Router
Tests the S1→S2→S3→S2→S4 call flow
"""

import socket
import time
import random
import sys
import argparse

class SIPTester:
    def __init__(self, target_host='localhost', target_port=5060, source_ip='10.0.0.1'):
        self.target_host = target_host
        self.target_port = target_port
        self.source_ip = source_ip
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.socket.settimeout(2.0)
        
    def generate_call_id(self):
        """Generate unique Call-ID"""
        return f"{random.randint(100000, 999999)}@{self.source_ip}"
    
    def generate_tag(self):
        """Generate unique tag"""
        return f"{random.randint(1000000, 9999999)}"
    
    def send_options(self):
        """Send SIP OPTIONS to test connectivity"""
        call_id = self.generate_call_id()
        
        message = f"""OPTIONS sip:router@{self.target_host}:{self.target_port} SIP/2.0\r
Via: SIP/2.0/UDP {self.source_ip}:5060;branch=z9hG4bK{random.randint(100000, 999999)}\r
From: <sip:test@{self.source_ip}>;tag={self.generate_tag()}\r
To: <sip:router@{self.target_host}>\r
Call-ID: {call_id}\r
CSeq: 1 OPTIONS\r
Max-Forwards: 70\r
Content-Length: 0\r
\r
"""
        
        print(f"Sending OPTIONS to {self.target_host}:{self.target_port}")
        print(f"From: {self.source_ip}")
        
        try:
            self.socket.sendto(message.encode(), (self.target_host, self.target_port))
            response, addr = self.socket.recvfrom(4096)
            response_str = response.decode('utf-8', errors='ignore')
            
            if '200 OK' in response_str:
                print("✓ Received 200 OK response")
                return True
            else:
                print(f"✗ Received: {response_str[:100]}")
                return False
                
        except socket.timeout:
            print("✗ Timeout - no response received")
            return False
        except Exception as e:
            print(f"✗ Error: {e}")
            return False
    
    def send_invite(self, ani='18005551111', dnis='18005552222'):
        """Send SIP INVITE to test call routing"""
        call_id = self.generate_call_id()
        from_tag = self.generate_tag()
        
        message = f"""INVITE sip:{dnis}@{self.target_host}:{self.target_port} SIP/2.0\r
Via: SIP/2.0/UDP {self.source_ip}:5060;branch=z9hG4bK{random.randint(100000, 999999)}\r
From: <sip:{ani}@{self.source_ip}>;tag={from_tag}\r
To: <sip:{dnis}@{self.target_host}>\r
Call-ID: {call_id}\r
CSeq: 1 INVITE\r
Contact: <sip:{ani}@{self.source_ip}:5060>\r
Max-Forwards: 70\r
Content-Type: application/sdp\r
Content-Length: 0\r
\r
"""
        
        print(f"\nSending INVITE:")
        print(f"  From (ANI): {ani}")
        print(f"  To (DNIS): {dnis}")
        print(f"  Source: {self.source_ip} (simulating S1)")
        
        try:
            self.socket.sendto(message.encode(), (self.target_host, self.target_port))
            response, addr = self.socket.recvfrom(4096)
            response_str = response.decode('utf-8', errors='ignore')
            
            # Parse response
            if '100 Trying' in response_str:
                print("✓ Received 100 Trying")
                
                # Wait for more responses
                try:
                    response, addr = self.socket.recvfrom(4096)
                    response_str = response.decode('utf-8', errors='ignore')
                    
                    if '302 Moved Temporarily' in response_str:
                        print("✓ Received 302 Moved Temporarily (call being routed)")
                        return True
                    elif '200 OK' in response_str:
                        print("✓ Received 200 OK")
                        return True
                    else:
                        print(f"  Received: {response_str[:100]}")
                        
                except socket.timeout:
                    pass
                    
            elif '403 Forbidden' in response_str:
                print("✗ Received 403 Forbidden (unauthorized source)")
                return False
            elif '503 Service Unavailable' in response_str:
                print("✗ Received 503 Service Unavailable")
                return False
            else:
                print(f"  Response: {response_str[:200]}")
                
        except socket.timeout:
            print("✗ Timeout - no response received")
            return False
        except Exception as e:
            print(f"✗ Error: {e}")
            return False
        
        return True
    
    def send_register(self, user='provider1'):
        """Send SIP REGISTER to test provider registration"""
        call_id = self.generate_call_id()
        from_tag = self.generate_tag()
        
        message = f"""REGISTER sip:{self.target_host}:{self.target_port} SIP/2.0\r
Via: SIP/2.0/UDP {self.source_ip}:5060;branch=z9hG4bK{random.randint(100000, 999999)}\r
From: <sip:{user}@{self.source_ip}>;tag={from_tag}\r
To: <sip:{user}@{self.target_host}>\r
Call-ID: {call_id}\r
CSeq: 1 REGISTER\r
Contact: <sip:{user}@{self.source_ip}:5060>\r
Expires: 3600\r
Max-Forwards: 70\r
Content-Length: 0\r
\r
"""
        
        print(f"\nSending REGISTER for {user}")
        
        try:
            self.socket.sendto(message.encode(), (self.target_host, self.target_port))
            response, addr = self.socket.recvfrom(4096)
            response_str = response.decode('utf-8', errors='ignore')
            
            if '200 OK' in response_str:
                print("✓ Received 200 OK - Registration successful")
                return True
            elif '401 Unauthorized' in response_str:
                print("  Received 401 Unauthorized - Authentication required")
                return False
            else:
                print(f"  Response: {response_str[:100]}")
                return False
                
        except socket.timeout:
            print("✗ Timeout - no response received")
            return False
        except Exception as e:
            print(f"✗ Error: {e}")
            return False

def test_call_flow(host='localhost', port=5060):
    """Test the complete S1→S2→S3→S2→S4 call flow"""
    
    print("=" * 60)
    print("Testing FreeSWITCH Router Call Flow")
    print("Flow: S1 → S2 (Router) → S3 → S2 → S4")
    print("=" * 60)
    
    # Test from S1
    print("\n1. Testing from S1 (10.0.0.1)")
    tester_s1 = SIPTester(host, port, '10.0.0.1')
    
    # Test connectivity
    if tester_s1.send_options():
        print("   S1 connectivity: OK")
    
    # Test call routing
    print("\n2. Testing call routing from S1")
    test_numbers = [
        ('18005551111', '18005552222'),  # Toll-free
        ('12125551234', '13105556789'),  # US standard
        ('14155551234', '16505554321'),  # Another US number
    ]
    
    for ani, dnis in test_numbers:
        if tester_s1.send_invite(ani, dnis):
            print(f"   Call {ani} → {dnis}: OK")
        else:
            print(f"   Call {ani} → {dnis}: FAILED")
        time.sleep(1)
    
    # Test from S3
    print("\n3. Testing from S3 (10.0.0.3)")
    tester_s3 = SIPTester(host, port, '10.0.0.3')
    
    if tester_s3.send_options():
        print("   S3 connectivity: OK")
    
    # S3 would send return calls with DID as DNIS
    print("\n4. Testing return call from S3")
    if tester_s3.send_invite('18005552222', '18005550001'):  # ANI is original DNIS, DNIS is DID
        print("   Return call: OK")
    
    print("\n" + "=" * 60)
    print("Test complete!")

def monitor_sip(host='localhost', port=5060, duration=60):
    """Monitor SIP traffic"""
    
    print(f"Monitoring SIP traffic on {host}:{port} for {duration} seconds...")
    print("Press Ctrl+C to stop")
    
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(('', 5061))  # Bind to different port for monitoring
    sock.settimeout(1.0)
    
    start_time = time.time()
    packet_count = 0
    
    try:
        while time.time() - start_time < duration:
            try:
                data, addr = sock.recvfrom(4096)
                packet_count += 1
                
                # Parse SIP message
                lines = data.decode('utf-8', errors='ignore').split('\r\n')
                if lines:
                    method = lines[0].split()[0] if lines[0].split() else "UNKNOWN"
                    print(f"[{time.strftime('%H:%M:%S')}] From {addr[0]}:{addr[1]} - {method}")
                    
            except socket.timeout:
                continue
            except KeyboardInterrupt:
                break
                
    except KeyboardInterrupt:
        pass
    
    print(f"\nReceived {packet_count} packets")

def main():
    parser = argparse.ArgumentParser(description='SIP Test Tool for FreeSWITCH Router')
    parser.add_argument('--host', default='localhost', help='Target host (default: localhost)')
    parser.add_argument('--port', type=int, default=5060, help='Target port (default: 5060)')
    parser.add_argument('--source', default='10.0.0.1', help='Source IP to simulate (default: 10.0.0.1)')
    parser.add_argument('--test', choices=['options', 'invite', 'register', 'flow', 'monitor'], 
                       default='flow', help='Test type (default: flow)')
    parser.add_argument('--ani', help='Calling number (ANI)')
    parser.add_argument('--dnis', help='Called number (DNIS)')
    parser.add_argument('--duration', type=int, default=60, help='Monitor duration in seconds')
    
    args = parser.parse_args()
    
    if args.test == 'options':
        tester = SIPTester(args.host, args.port, args.source)
        tester.send_options()
        
    elif args.test == 'invite':
        tester = SIPTester(args.host, args.port, args.source)
        ani = args.ani or '18005551111'
        dnis = args.dnis or '18005552222'
        tester.send_invite(ani, dnis)
        
    elif args.test == 'register':
        tester = SIPTester(args.host, args.port, args.source)
        tester.send_register()
        
    elif args.test == 'flow':
        test_call_flow(args.host, args.port)
        
    elif args.test == 'monitor':
        monitor_sip(args.host, args.port, args.duration)

if __name__ == '__main__':
    main()
