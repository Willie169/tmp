Here's my current Android phone network connection configuration.

## Apps

- Island (F-Droid) manages Work Profile
- TrackerControl (F-Droid) in Personal Profile as VPN of Personal Profile
  - Tracker blocker
  - UDP tracker blocker
  - Port forwarding: 53/UDP -> 5354, 53/TCP -> 5354
  - Socks5 proxy: -> 1080
- InviZible Pro (F-Droid) proxy mode in Personal Profile
  - DNSCrypt server at port 5354
    - DNSCrypt servers: adguard-dns-unfiltered-doh/adguard-dns-unfiltered-doh-ipv6/cloudflare/cloudflare-ipv6
    - Bootstrap resolver: 1.1.1.1, 1.0.0.1, 2606:4700:4700::1111, 2606:4700:4700::1001, 94.140.14.140, 94.140.14.141, 2a10:50c0::1:ff, 2a10:50c0::2:ff
    - Remote blacklist: https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
    - Socks5 proxy: -> 1080 (without Tor) or 9051 (with Tor)
  - (Optional) Tor server at port 9051
    - Socks5 proxy: -> 1080
- Sock5 (GitHub) in Work Profile:
  - Socks5 server at port 1080 with UDP ASSOCIATE
- Tailscale (F-Droid) in Work Profile as VPN of Work Profile
  - Using Tailscale DNS

## Without Tor

- Personal Profile UDP or TCP requests at port 53 -> TrackerControl port forwarding to port 5354 -> InviZible Pro DNS server at port 5354 outbound through Socks5 proxy at port 1080 -> Socks5 Sock5 server at port 1080 -> Tailscale -> DNS resolved
- Personal Profile other requests -> TrackerControl outbound through Socks5 proxy at port 1080 -> Socks5 Sock5 server at port 1080 -> Tailscale -> Outbound
- Work Profile requests -> Tailscale -> Outbound

## With Tor

- Personal Profile UDP or TCP requests at port 53 -> TrackerControl UDP port forwarding to port 5354 -> InviZible Pro DNS server at port 5354 outbound through Socks5 proxy at port 9051 -> InviZible Pro Tor Socks5 server at port 9051 outbound through Socks5 proxy at port 1080 -> Socks5 Sock5 server at port 1080 -> Tailscale -> DNS resolved
- Personal Profile other requests -> TrackerControl outbound through Socks5 proxy at port 9051 -> InviZible Pro Tor Socks5 server at port 9051 outbound through Socks5 proxy at port 1080 -> Socks5 Sock5 server at port 1080 -> Tailscale -> Outbound
- Work Profile requests -> Tailscale -> Outbound
