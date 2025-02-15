@tool
extends TextureButton

#Only expands horizontally, then it is made square here. #Can't fill vertically, because that would squish them all into the screen and remove scroll functionality. #AspectRatioContainer didn't work because the button just overflows the Continer. 
func _on_resized():
	custom_minimum_size.y = size.x
