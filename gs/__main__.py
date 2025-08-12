import asyncio
import json
from pathlib import Path
from subprocess import check_output
from bleak import BleakScanner

HOSTS = Path("hosts").read_text().splitlines()


async def run_http(host: str):
    """Run load test in background"""
    loop = asyncio.get_running_loop()
    while True:
        try:
            # Run blocking command in a thread
            await loop.run_in_executor(
                None,
                check_output,
                ["oha", "-n", "1000000", "-c", "1000", f"http://{host}"],
            )
            print(f"[HTTP OK] {host}")
        except Exception as e:
            print(f"[HTTP ERROR] {host} -> {e}")
        await asyncio.sleep(1)  # Avoid CPU hogging


async def scan_devices():
    """Continuously scan BLE devices"""
    while True:
        devices = await BleakScanner.discover()
        for device in devices:
            print(json.dumps({"address": device.address, "name": device.name}))
        await asyncio.sleep(5)  # scan interval


async def main():
    # Create tasks for HTTP hosts + BLE scanner
    tasks = [scan_devices()] + [run_http(host) for host in HOSTS]
    await asyncio.gather(*tasks)


if __name__ == "__main__":
    asyncio.run(main())
