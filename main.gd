extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("PUXAR"):
		_on_puxar_button_up()
	elif event.is_action_pressed("MANTER"):
		_on_manter_button_up()
	elif event.is_action_pressed("REINICIAR"):
		_on_btn_reset_button_up()
	elif event.is_action_pressed("MELHOR DE 5"):
		_on_melhor_de_5_button_up()
	elif event.is_action_pressed("MELHOR DE 3"):
		_on_melhor_de_3_button_up()
		

@onready
var board = get_node('Board')

@onready
var end_game_screen = get_node('EndGame')

var wins_player_1 = 0
var wins_player_2 = 0

var melhor_3 = 3
var melhor_5 = 5

var wins_needed = 0

var game_over = false

var player_1 : Player
var player_2 : Player
var player_1_continue = true
var player_2_continue = true
var player_active = true

var deck

func generate_deck():
	var cards = []
	var houses = ["paus", "espadas", "ouro", "copas"]
	
	for np in houses:
		for i in range(1, 14):
			cards.append( Card.new(i, np) )
	return cards

func updateBoard():
	board.text = 'Vez do ' + (player_1.player_name if player_active else player_2.player_name)
	board.text += ' | Jogador ' + player_1.player_name + ' - ' + str(player_1.score) + ' pontos '
	board.text += ' | Jogador ' + player_2.player_name + ' - ' + str(player_2.score) + ' pontos '
	
	board.text += '\n' + player_1.show_hands()
	board.text += '\n' + player_2.show_hands()
	
	if wins_needed > 0:
		board.text += '\nVitórias: ' + player_1.player_name + ' - ' + str(wins_player_1) + ' | ' + player_2.player_name + ' - ' + str(wins_player_2)

func end_game():
	if game_over:
		return
	game_over = true
	var vencedor = ''
	if( player_1.score == player_2.score ):
		end_game_screen.text = 'Os jogadores optaram por empate'
	elif( player_1.score > 21 ):
		vencedor = player_2.player_name
	elif( player_2.score > 21 ):
		vencedor = player_1.player_name
	elif(player_1.score > player_2.score ):
		vencedor = player_1.player_name
	else:
		vencedor = player_2.player_name
	
	if vencedor == player_1.player_name:
		wins_player_1 += 1
	else:
		wins_player_2 += 1
		
				
	end_game_screen.text = vencedor + ' venceu essa rodada !!'
	
	if wins_needed > 0:
		if wins_player_1 >= wins_needed:
			end_game_screen.text = 'PARABENS AO PLAYER A FIM DE JOGO'
			game_over = true
		elif wins_player_2 >= wins_needed:
			end_game_screen.text = 'PARABENS AO PLAYER B FIM DE JOGO'
			game_over = true
	
	

func _ready():
	player_1 = Player.new('A')
	player_2 = Player.new('B')
	
	print('Gerando baralho')
	deck = generate_deck()
	
	print('Embaralhando')
	deck.shuffle()

	print('Entregando duas cartas para cada jogador')
	board.text += ''
	
	updateBoard()

func _on_puxar_button_up() -> void:
	if game_over:
		return

	if( player_active ):
		player_1.take_card( deck )
	else:
		player_2.take_card( deck )
		
	if( player_1.score == 21 or player_2.score == 21 ):
		end_game()
	elif( player_1.score < 22 and player_2.score < 22 ):
		player_active = not player_active
	else:
		end_game()
		
	updateBoard()

func _on_manter_button_up() -> void:

	if game_over:
		return
		
	if( player_active):
		player_1_continue = false
	else:
		player_2_continue = false
	
	if( not player_1_continue and not player_2_continue ):
		end_game()
	player_active = not player_active


func _on_btn_reset_button_up() -> void:
	
	if wins_needed > 0 and (wins_player_1 >= wins_needed or wins_player_2 >= wins_needed):
		return
	
	game_over = false
	
	player_1_continue = true
	player_2_continue = true
	game_over = false
	print('Gerando baralho')
	deck = generate_deck()
	
	print('Embaralhando')
	deck.shuffle()	
	player_active = true

	end_game_screen.text = ''
	
	# limpar as mãos dos jogadores
	player_1.reset()
	player_2.reset()
	
	updateBoard()

func _on_melhor_de_5_button_up() -> void:
	
	player_1_continue = true
	player_2_continue = true
	game_over = false
	player_active = true
	player_1.reset()
	player_2.reset()
	
	wins_needed = melhor_5
	wins_player_1 = 0
	wins_player_2 = 0

	deck = generate_deck()
	deck.shuffle()
	
	end_game_screen.text = ''
	updateBoard()
	board.text += '\nQuem chegar a %d pontos primeiro vence!!!' % wins_needed
	

func _on_melhor_de_3_button_up() -> void:
	player_1_continue = true
	player_2_continue = true
	game_over = false
	player_active = true
	player_1.reset()
	player_2.reset()
	
	wins_needed = melhor_3
	wins_player_1 = 0
	wins_player_2 = 0

	deck = generate_deck()
	deck.shuffle()

	end_game_screen.text = ''
	updateBoard()
	board.text += '\nQuem chegar a %d pontos primeiro vence!!!' % wins_needed
