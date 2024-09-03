Player.destroy_all
Match.destroy_all

Player.create(name: 'Player 1', games_lost: 0, games_won: 0, sets_won: 0)
Player.create(name: 'Player 2', games_lost: 0, games_won: 0, sets_won: 0)
Player.create(name: 'Player 3', games_lost: 0, games_won: 0, sets_won: 0)
Player.create(name: 'Player 4', games_lost: 0, games_won: 0, sets_won: 0)
Player.create(name: 'Player 5', games_lost: 0, games_won: 0, sets_won: 0)
Player.create(name: 'Player 6', games_lost: 0, games_won: 0, sets_won: 0)
Player.create(name: 'Player 7', games_lost: 0, games_won: 0, sets_won: 0)
Player.create(name: 'Player 8', games_lost: 0, games_won: 0, sets_won: 0)

Match.create(match_date: '2022-09-01')
Match.create(match_date: '2022-09-02')
Match.create(match_date: '2022-09-03')
Match.create(match_date: '2022-09-04')

puts 'Seed finished'
