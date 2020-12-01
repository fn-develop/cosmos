class AddLastVisitYmdToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :ymd_num, :integer, default: :null, after: :address2
  end
end
