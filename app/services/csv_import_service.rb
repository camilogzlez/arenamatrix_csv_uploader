class CsvImportService
  require 'csv'

  def call(file)
    opened_file = File.open(file)
    options = { headers: true, col_sep: ';' }
    CSV.foreach(opened_file, **options) do |row|
      client = Client.find_or_create_by(last_name: row['Nom'],
                                        first_name: row['Prenom'],
                                        email: row['Email'],
                                        address: row['Adresse'],
                                        zip_code: row['Code postal'],
                                        country: row['Pays'],
                                        age: row['Age'],
                                        sex: row['Sexe']
                                        )
      spectacle = Spectacle.find_or_create_by(spectacle_external_id: row['Cle spectacle'],
                                              spectacle_name: row['Spectacle']
                                              )
      representation = Representation.find_or_create_by(representation_external_id: row['Cle representation'],
                                                        representation_name: row['Representation'],
                                                        representation_date: row['Date representation'],
                                                        representation_time: row['Heure representation'],
                                                        representation_end_date: row['Date fin representation'],
                                                        representation_end_time: row['Heure fin representation'],
                                                        spectacle_id: spectacle.id
                                                        )
      reservation = Reservation.find_or_create_by(reservation_external_id: row['Reservation'],
                                                  ticket_number: row['Numero billet'],
                                                  reservation_date: row['Date reservation'],
                                                  reservation_time: row['Heure reservation'],
                                                  sales_chanel: row['Filiere de vente'],
                                                  prix: row['Prix'],
                                                  type_of_product: row['Type de produit'],
                                                  client_id: client.id,
                                                  representation_id: representation.id,
                                                  spectacle_id: spectacle.id
                                                  )
    end
  end
end
