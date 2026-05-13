# 2026-01-26T18:09:47.020990100
import vitis

client = vitis.create_client()
client.set_workspace(path="VITIS")

platform = client.get_component(name="platform")
status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

status = platform.build()

comp.build()

