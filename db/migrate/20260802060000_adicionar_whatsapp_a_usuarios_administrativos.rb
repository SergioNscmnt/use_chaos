class AdicionarWhatsappAUsuariosAdministrativos < ActiveRecord::Migration[8.1]
  def change
    add_column :usuarios_administrativos, :whatsapp, :string, limit: 15
  end
end
