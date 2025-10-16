#!/usr/bin/env python3
import sys
import requests


def main():
    url = sys.argv[1] if len(sys.argv) > 1 else "http://localhost:4499"
    timeout = float(sys.argv[2]) if len(sys.argv) > 2 else 5.0
    try:
        r = requests.get(url, timeout=timeout)
        if 200 <= r.status_code < 400:
            print(f"UP {r.status_code} {url}")
            sys.exit(0)
        else:
            print(f"DOWN {r.status_code} {url}")
            sys.exit(1)
    except Exception as e:
        print(f"DOWN ERR {url} {e}")
        sys.exit(2)


if __name__ == "__main__":
    main()


