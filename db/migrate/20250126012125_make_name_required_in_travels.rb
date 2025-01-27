class MakeNameRequiredInTravels < ActiveRecord::Migration[6.1]
  def change
    change_column_null :travels, :name, false
  end
end
