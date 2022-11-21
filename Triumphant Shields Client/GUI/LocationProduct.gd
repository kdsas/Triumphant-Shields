extends Node


var location =null
var product =null
var price =0
var main
var forced_price_change=true
func _ready():
	
	
	pass
	
	
func _init(_main, _location,_product):
	main=_main
	location=_location
	product=_product
	main.connect("Arrival", self,"UpdateLocationProduct")
	
func UpdateLocationProduct(_location):
	if _location==location:
	   randomize()
	   if randf()>.5 or forced_price_change:
		   forced_price_change=false
		   price =product.CalculatePrice()	
	   product.product_panel.UpdatePrice(price)
	   #print("signal processed: product="+ product.product_name+",location="+location.location_name)
	


   
