extends Panel


var cash =200
var qty1=0

const battle_health_label="Battle Health: "

var location=preload("res://GUI/Location.gd")
var product=preload("res://GUI/Product.gd")
var location_product=preload("res://GUI/LocationProduct.gd")
var product_panel=preload("res://GUI/ProductPanel.tscn")
var battle_panel_scene=load("res://GUI/BattlePanel.tscn")
var battle_panel_over=preload("res://GUI/NPCBattleOverPanel.tscn")
var battle_panel_complete=preload("res://GUI/NPCBattleCompletePanel.tscn")

var battle
var locations=[]
var location_data=[{'name': 'Vitila'},{'name': 'Iraza'},{'name': 'Titan'},{'name': 'Milanda'} ]
var current_location_index=0
var sum=0
var product_data=[{'name':'Loot1', 'min_price':2, 'max_price':25}, 
{'name':'Loot2', 'min_price':15, 'max_price':85},
{'name':'Cherries', 'min_price':105, 'max_price':585},
{'name':'Flower1', 'min_price':120, 'max_price':5000}]

var firm_name="Triumphant Shields Trader Store"

var products=[]

signal Arrival


func _ready():
	CreateProducts()
	CreateProductPanels()
	CreateLocations()
	CreateLocationProducts()
	PrintLocationProducts()
	Arrival()
	UpdateUI()
	
	
func CreateLocationProducts():
	for _location in locations:
		for _product in products:
			var _location_product=location_product.new(self,_location,_product)
			_location.location_products.append(_location_product)	
	
func CreateProducts():
	for _product in product_data:
	   var prod=product.new(_product.name, _product.min_price, _product.max_price)
	   products.append(prod)
	  


	
	   
func PutProducts():
	 Global.inv_count=true
	 InventoryCanvasLayer.increase_loot1()		
	 InventoryCanvasLayer.increase_loot2()
	 InventoryCanvasLayer.increase_cherries()
	 InventoryCanvasLayer.increase_flower1()
	 if products.count("Loot1")<=0:
			  InventoryCanvasLayer.generate_lootOne_icon()
			  
	 if products.count("Loot2")<=0:
			  InventoryCanvasLayer.generate_lootTwo_icon()	
			 
	 if products.count("Cherries")<=0:
			  InventoryCanvasLayer.generate_cherries_icon()
	
	 if products.count("Flower1")<=0:
			   InventoryCanvasLayer.generate_flowerOne_icon()
			   
	
func PrintLocationProducts():
	for _location in locations:
		for _location_product in	_location.location_products:
			print("Product: %s, Location: %s,Price %s"%[_location_product.location.location_name, _location_product.product.product_name,_location_product.price])
	
func CreateLocations():
	for _location in location_data:
	   var location1=location.new()
	   location1.location_name=_location.name
	   locations.append(location1)
	
	
func Updatehealth():
	$BattleHealthLabel.text="%s %s / %s" % [battle_health_label,Global.battle_health,Global.max_battle_health]
	
func UpdateNohealth():
	$BattleHealthLabel.text="%s %s / %s" % [battle_health_label,0,Global.max_battle_health]
	
func UpdateUI():
	$FirmLabel.text=firm_name
	$CashLabel.text="Cash: $" +str(cash)
	$LocationLabel.text="Location: " +locations[current_location_index].location_name	
	
func CreateProductPanels():
	for _product in products:
		var _product_panel=product_panel.instance()
		_product.product_panel=_product_panel
		_product_panel.init(_product)
		_product_panel.UpdateUI(_product.product_name)
		$ProductListContainer.add_child(_product_panel)

func Arrival():
	CheckForNPCs()
	emit_signal("Arrival", locations[current_location_index])
	UpdateUI()
	Updatehealth()

func CheckForNPCs():
	var battle=battle_panel_scene.instance()
	battle.init(self)
	self.add_child(battle)		
	
func Departure(_new_location_index):
	if current_location_index!=_new_location_index:
	   current_location_index=_new_location_index
	   Arrival()
	   UpdateUI()
	else:
		print("You're already here")

func _process(delta):
	if Global.battle_health==0:
		BattleLost()
	if Global.quest_accept:
	   yield(get_tree().create_timer(60),"timeout")		   
	   BattleLost()

func _on_buyButton_pressed():
	for _product in products:
		var price=_product.price
		var qty=_product.product_panel.GetQty()
		sum+=price*qty
	if sum<=cash:
		for _product in products:
		  var qty=_product.product_panel.GetQty()
		  _product.hold+=qty
		  qty1+=1
		  _product.product_panel.UpdateHold(qty1)
		cash-=sum
		UpdateUI()
		PutProducts()
		if Global.quest_accept==true and InventoryCanvasLayer.cherries_count>=10 and Global.Thursday==true:
			BattleComplete()

		if Global.quest_accept==true and InventoryCanvasLayer.flower1_count>=10 and Global.Friday==true:
			BattleComplete()
			
		if Global.quest_accept==true and InventoryCanvasLayer.loot1_count>=10 and Global.Saturday==true:
			BattleComplete()	

func BattleLost():
	$buyButton.hide()
	$sellButton.hide()
	$vitilaButton.hide()
	$irazaButton.hide()
	$titanButton.hide()
	$milandaButton.hide()
	var battle_over=battle_panel_over.instance()
	add_child(battle_over)
	yield(get_tree().create_timer(3),"timeout")	   
	queue_free()
	
func BattleComplete():
	$buyButton.hide()
	$sellButton.hide()
	$vitilaButton.hide()
	$irazaButton.hide()
	$titanButton.hide()
	$milandaButton.hide()
	Global.completed=true
	Global.quest_status = Global.QuestStatus.COMPLETED
	var battle_complete=battle_panel_complete.instance()
	add_child(battle_complete)
	yield(get_tree().create_timer(3),"timeout")		   
	queue_free()	

func _on_sellButton_pressed():
	for _product in products:
		var qty = _product.product_panel.GetQty()
		if qty <_product.hold:
			_product.hold-=qty
			qty1-=1
			_product.product_panel.UpdateHold(qty1)         
			sum+=qty*_product.price
	cash+=sum
	UpdateUI()	
	
		






func _on_openStoreButton_toggled(button_pressed):
	if button_pressed==true:
	   show()
	  
	else:
		 hide()
		
