# 2026-02-01T17:22:12.877462300
import vitis

client = vitis.create_client()
client.set_workspace(path="VITIS")

platform = client.get_component(name="platform")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../FIR.xsa")

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../FIR.xsa")

status = platform.build()

