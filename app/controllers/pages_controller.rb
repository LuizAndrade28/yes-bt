class PagesController < ApplicationController
  def home
    # Inicializando variáveis de jogadores e Ordenando os jogadores
    @female_players = Player.where(gender: 'Feminino').where("matches_count > 0").order(sets_won: :desc, games_balance: :desc)
    @players_ranking = Player.where("matches_count > 0").order(sets_won: :desc, games_balance: :desc)
  end

  def delete_all_data
    # Deletando todos os playplayers
    PlayPlayer.delete_all

    # Deletando todos os jogos
    Play.delete_all

    # Deletando todos os jogos
    Match.delete_all

      # Deletando todos os jogadores
    Player.delete_all

    # Redirecionando para a página inicial
    redirect_to root_path
  end

  def export_data
    # # Inicializando variáveis de jogadores e Ordenando os jogadores
    # @players = Player.all.order(name: :asc)
    # @female_players
    # @players_ranking

    # csv_data = CSV.generate(headers: true) do |csv|
    #   csv << ["Coluna 1", "Coluna 2"] # Cabeçalhos

    #   @players.each do |record|
    #     csv << [record.coluna1, record.coluna2]
    #   end
    # end

    # send_data csv_data, filename: "data-#{Date.today}.csv"

    @players_ranking = Player.all.order(games_won: :desc)
    @female_players = Player.where(gender: 'Feminino').order(games_won: :desc)
    @match_last_date_year = Match.last.match_date.year

    p = Axlsx::Package.new #Aqui
    wb = p.workbook

    # Primeira aba (Planilha 1)
    wb.add_worksheet(name: "Ranking Geral") do |sheet|
      sheet.add_row ["Posicao", "Nome", "Pontos", "Confrontos", "Games ganhos", "Games Perdidos", "Saldo games"]
      @players_ranking.each_with_index do |player, index|
        sheet.add_row [index+1, player.name, player.sets_won, player.matches_count, player.games_won, player.games_lost, player.games_balance]
      end
    end

    # Segunda aba (Planilha 2)
    wb.add_worksheet(name: "Ranking feminino") do |sheet|
      sheet.add_row ["Posicao", "Nome", "Pontos", "Confrontos", "Games ganhos", "Games Perdidos", "Saldo games"]
      @female_players.each_with_index do |female_player, index|
        sheet.add_row [index+1, female_player.name, female_player.sets_won, female_player.matches_count, female_player.games_won, female_player.games_lost, female_player.games_balance]
      end
    end

    # Enviar o arquivo para download
    # temp = Tempfile.new("data.xlsx")
    # p.serialize(temp.path)
    # send_file temp.path, filename: "data-#{@match_last_date_year}-#{Date.today}.xlsx"
    # temp.close

    # Enviar o arquivo para download
    temp = Tempfile.new(["data", ".xlsx"], binmode: true)
    p.serialize(temp.path)
    send_file temp.path, filename: "data-#{@match_last_date_year}-#{Date.today}.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

    # Fechar o arquivo temporário
    temp.close

    if temp.close == true
      temp.unlink
    end
  end
end
