extends Panel

var product


func init(_product):
	product=_product
	_product.connect("Location_Price_Updated", self, "UpdateUI")


func UpdateUI(_product_name):
	$ProductName.text="Product: "+_product_name
	
func UpdatePrice(price):
	$Price.text="Loot Cost $: "+str(price)	
	
	
func GetQty():
	var qty= $Quantity.text
	$Quantity.text=""
	return int(qty)
		
	
func UpdateHold(qty):
	$Hold.text="Weight(Pounds): "+ str(qty)
