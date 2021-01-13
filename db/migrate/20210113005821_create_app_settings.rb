class CreateAppSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :app_settings do |t|
      t.string  :management_company_name, default: ''
      t.text    :privacy_policy

      t.timestamps
    end
  end
end
