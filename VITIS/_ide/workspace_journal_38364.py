# 2026-01-02T13:29:14.345393900
import vitis

client = vitis.create_client()
client.set_workspace(path="VITIS")

platform = client.get_component(name="platform")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../FIR.xsa")

status = platform.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../FIR.xsa")

status = platform.build()

vitis.dispose()

vitis.dispose()

