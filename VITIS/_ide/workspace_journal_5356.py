# 2025-12-19T14:58:19.593491200
import vitis

client = vitis.create_client()
client.set_workspace(path="VITIS")

platform = client.get_component(name="platform")
status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

vitis.dispose()

