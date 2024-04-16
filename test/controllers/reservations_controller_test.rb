require "test_helper"
require 'csv'

class ReservationsControllerTest < ActionDispatch::IntegrationTest
require 'test_helper'

  setup do
    Reservation.delete_all
    Client.delete_all
  end

  test "should import CSV file and create records" do
    puts "-> Importing a csv file"
    csv_file_path = 'test/test_data/sample.csv'
    post import_reservations_path, params: { file: fixture_file_upload(csv_file_path, 'text/csv') }
    assert_equal expected_reservation_count(csv_file_path), Reservation.count
  end

  private

  def expected_reservation_count(csv_file_path)
     CSV.foreach(csv_file_path, headers: true).count
  end

  def expected_client_count
    #to implement
  end

end
