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
      # @dropdown_options = Spectacle.pluck(:id, :name).map { |id, name| { id: id, label: "#{name} (ID: #{id})" } }
      @dropdown_options = Spectacle.all.map { |spectacle| spectacle.id }
    when 'by_representation'
      @dropdown_options = Representation.pluck(:id, :date).map { |id, date| { id: id, label: "#{date} (ID: #{id})" } }
    else
      @dropdown_options = []
    end
  reservations_count(params[:scope], params[:id])
  reservations_clients_count
  reservations_clients_average_age
  reservations_average_price
end

private

def reservations_count(scope, *id)
  case scope
  when 'all'
    @reservations_count = Reservation.all.group_by { |reservation| reservation.reservation_external_id }
                  .transform_values(&:uniq).count
  when 'spectacle_external_id'
    @reservations_count = Reservation.by_spectacle(id).count
  when 'representation_external_id'
    @reservations_count = Reservation.by_representation(id).count
  else
    @reservations_count = 0
  end
end


  def reservations_clients_count
    @clients_count = Client.all.count
  end

    def reservations_clients_average_age
     ages = Client.all.map {|client| client.age }.compact
     sum_ages = ages.reduce(0, :+)
     @average_age = sum_ages.to_i / ages.count
  end

  def reservations_average_price
     reservation_prices = Reservation.all.map {|reservation| reservation.prix }.compact
     sum_prices = reservation_prices.reduce(0, :+)
     @average_reservation_price = (sum_prices.to_f/ reservation_prices.count).round(2)

    # representation_prices = Representation.all.reservations.all.map {|representation| representation.prix }.compact
    #  sum_prices = representation_prices.reduce(0, :+)
    #  @average_representation_price = (sum_prices.to_f / representation_prices.count).round(2)
  end

end
