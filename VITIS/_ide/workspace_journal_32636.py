# 2025-12-23T21:32:03.840525700
import vitis

client = vitis.create_client()
client.set_workspace(path="VITIS")

platform = client.get_component(name="platform")
status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

vitis.dispose()

