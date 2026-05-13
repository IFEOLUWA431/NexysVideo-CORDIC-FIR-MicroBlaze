# 2026-05-08T13:22:08.005326500
import vitis

client = vitis.create_client()
client.set_workspace(path="VITIS")

platform = client.get_component(name="platform")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../FIR.xsa")

status = platform.build()

status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

vitis.dispose()

vitis.dispose()

