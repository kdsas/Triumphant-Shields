extends Node

var product_name="[product name]"
var min_price=3
var max_price=15
var price=1
var product_panel=null
var hold=0
var current_location_product=null

signal Location_Price_Updated

func _ready():
	randomize()
	pass

func _init(_product_name,_min_price, _max_price):
	product_name=_product_name
	min_price=_min_price
	max_price=_max_price
	
	
	
	
func CalculatePrice():
	randomize()
	return int(rand_range(min_price,max_price))	
	

func SetCurrentLocationProduct(_location_product):
	current_location_product=_location_product
	emit_signal("Location_Price_Updated",price)


