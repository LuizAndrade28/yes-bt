Player.destroy_all
Match.destroy_all

player1 = Player.create(name: 'Player 1', games_lost: 0, games_won: 0, sets_won: 0)
player2 = Player.create(name: 'Player 2', games_lost: 0, games_won: 0, sets_won: 0)
player3 = Player.create(name: 'Player 3', games_lost: 0, games_won: 0, sets_won: 0)
player4 = Player.create(name: 'Player 4', games_lost: 0, games_won: 0, sets_won: 0)
player5 = Player.create(name: 'Player 5', games_lost: 0, games_won: 0, sets_won: 0)
player6 = Player.create(name: 'Player 6', games_lost: 0, games_won: 0, sets_won: 0)
player7 = Player.create(name: 'Player 7', games_lost: 0, games_won: 0, sets_won: 0)
player8 = Player.create(name: 'Player 8', games_lost: 0, games_won: 0, sets_won: 0)

match1 = Match.create(match_date: '2022-09-01')
match2 = Match.create(match_date: '2022-09-02')
match3 = Match.create(match_date: '2022-09-03')
match4 = Match.create(match_date: '2022-09-04')

puts 'Seed finished'
