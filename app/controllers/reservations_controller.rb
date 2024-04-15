class ReservationsController < ApplicationController

  def import
    # return redirect_to request.referer, notice: 'No file added' if params[:file].nil?
    # return redirect_to request.referer, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'

    CsvImportService.new.call(params[:file])

    redirect_to request.referer, notice: 'Import started...'
  end

  def index
    @reservations = Reservation.all
  end

  def indicators
    case params[:scope]
    when 'by_spectacle'
      @dropdown_options = Spectacle.all.map { |spectacle| spectacle.id }
      @selected_scope = 'by_spectacle'  # Set the selected scope for the dropdown
    when 'by_representation'
      # @dropdown_options = Representation.pluck(:id, :date).map { |id, date| { id: id, label: "#{date} (ID: #{id})" } }
      @dropdown_options = Representation.all.map { |representation| representation.id }
      @selected_scope = 'by_representation'  # Set the selected scope for the dropdown
    else
      @dropdown_options = []
      @selected_scope = 'all'  # Set the selected scope for the dropdown
    end

    if params[:id]
      reservations_count(params[:scope], params[:id])
      reservations_clients_count(params[:scope], params[:id])
      reservations_clients_average_age(params[:scope], params[:id])
      reservations_average_price(params[:scope], params[:id])
    end
  end

  private

  def reservations_count(scope, *id)
    case scope
    when 'all'
      @reservations_count = Reservation.all.group_by { |reservation| reservation.reservation_external_id }
                    .transform_values(&:uniq).count
    when 'by_spectacle'
      @reservations_count = Reservation.by_spectacle(id).count
    when 'by_representation'
      @reservations_count = Reservation.by_representation(id).count
    end
  end

  def reservations_clients_count(scope, *id)
    case scope
    when 'all'
      @clients_count = Client.all.count
    when 'by_spectacle'
      @clients_count = Reservation.by_spectacle(id).map {|spectacle| spectacle.client}.count
    when 'by_representation'
      @clients_count = Reservation.by_representation(id).map {|representation| representation.client}.count
    end
  end

  def reservations_clients_average_age(scope, *id)
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

  def reservations_average_price(scope, *id)
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
    @average_reservation_price = (sum_prices.to_f/ reservation_prices.count).round(2)
  end

end

