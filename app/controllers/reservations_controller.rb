class ReservationsController < ApplicationController

  def import
    return redirect_to request.referer, notice: 'Aucun fichier ajouté!' if params[:file].nil?
    return redirect_to request.referer, notice: 'Seuls les fichiers CSV sont autorisés.!' unless params[:file].content_type == 'text/csv'

    CsvImportService.new.call(params[:file])
    redirect_to reservations_path
    flash[:success] = "Yay! 🎉 Vous avez importé les réservations avec succès."
  end

  def index
    @reservations = Reservation.all
  end

  def indicators
    case params[:scope]
    when 'by_spectacle'
      @dropdown_options = Spectacle.all.map { |spectacle| { id: spectacle.id, name: spectacle.spectacle_name } }
      @selected_scope = 'by_spectacle'
    when 'by_representation'
      @dropdown_options = Representation.all.map { |representation| { id: representation.id,
                                                                      name: "#{representation.representation_external_id}-#{representation.representation_name}-#{formatted_date(representation.representation_date)} #{formatted_time(representation.representation_time)}" }}
      @selected_scope = 'by_representation'
    else
      @dropdown_options = []
      @selected_scope = 'all'
    end

    if params[:id].present?
      id = params[:id].match(/:id=>(\d+)/)[1]
      reservations_count(params[:scope], id)
      reservations_clients_count(params[:scope], id)
      reservations_clients_average_age(params[:scope], id)
      reservations_average_price(params[:scope], id)
    end
  end

  private

  def reservations_count(scope, id)
    case scope
    when 'all'
      @reservations_count = Reservation.all.group_by { |reservation| reservation.reservation_external_id }
                    .transform_values(&:uniq).count
    when 'by_spectacle'
      @reservations_count = Reservation.by_spectacle(id).all.group_by { |reservation| reservation.reservation_external_id }
                    .transform_values(&:uniq).count
    when 'by_representation'
      @reservations_count = Reservation.by_representation(id).all.group_by { |reservation| reservation.reservation_external_id }
                    .transform_values(&:uniq).count
    end
  end

  def reservations_clients_count(scope, id)
    case scope
    when 'all'
      @clients_count = Client.all.count
    when 'by_spectacle'
      @clients_count = Reservation.by_spectacle(id).map {|spectacle| spectacle.client}.uniq.count
    when 'by_representation'
      @clients_count = Reservation.by_representation(id).map {|representation| representation.client}.uniq.count
    end
  end

  def reservations_clients_average_age(scope, id)
    case scope
    when 'all'
      ages = Client.all.map {|client| client.age }.compact
    when 'by_spectacle'
      ages = Reservation.by_spectacle(id).map {|spectacle| spectacle.client.age}.compact
    when 'by_representation'
      ages = Reservation.by_representation(id).map {|representation| representation.client.age}.compact
    end
    sum_ages = ages.reduce(0, :+)
    sum_ages == 0 ? @average_age = "Sans information": (@average_age = sum_ages.to_i / ages.count)
  end

  def reservations_average_price(scope, id)
    reservation_prices = Reservation.all.map {|reservation| reservation.prix }.compact

    case scope
    when 'all'
      reservation_prices = Reservation.all.map {|reservation| reservation.prix }
    when 'by_spectacle'
      reservation_prices = Reservation.by_spectacle(id).map {|reservation| reservation.prix}
    when 'by_representation'
      reservation_prices = Reservation.by_representation(id).map {|representation| representation.prix}
    end
    sum_prices = reservation_prices.reduce(0, :+)
    @average_reservation_price = sprintf("%.2f", sum_prices.to_f / reservation_prices.count)
  end

end
